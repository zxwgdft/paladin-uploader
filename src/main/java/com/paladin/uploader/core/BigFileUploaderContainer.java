package com.paladin.uploader.core;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class BigFileUploaderContainer {

	private static Logger logger = LoggerFactory.getLogger(BigFileUploaderContainer.class);

	@Value("${paladin.upload.dir}")
	private String targetFolder;	
	private long chunkSize = 5 * 1024 * 1024;

	@PostConstruct
	protected void initialize() {
		// 创建目录
		Path root = Paths.get(targetFolder);
		try {
			Files.createDirectories(root);
		} catch (IOException e) {
			throw new RuntimeException("创建大文件存放目录异常[" + targetFolder + "]", e);
		}
		logger.info("大文件存放目录：" + targetFolder);
	}

	private Map<String, BigFileUploader> bigFileUploaderMap = new HashMap<>();

	public BigFileUploader getOrCreateUploader(String id, int chunkCount, String fileName) {
		BigFileUploader uploader = bigFileUploaderMap.get(id);
		if (uploader == null) {
			synchronized (bigFileUploaderMap) {
				uploader = bigFileUploaderMap.get(id);
				if (uploader == null) {
					uploader = new BigFileUploader(id, chunkCount, chunkSize, targetFolder, fileName);
					bigFileUploaderMap.put(id, uploader);
				}
			}
		}
		
		return uploader;
	}

	public boolean checkFileChunk(String id, int chunkIndex) {
		BigFileUploader uploader = bigFileUploaderMap.get(id);
		if (uploader != null) {
			return uploader.checkFileChunk(chunkIndex);
		}
		return false;
	}

	public int uploadFileChunk(String id, int chunkIndex, byte[] data) {
		BigFileUploader uploader = bigFileUploaderMap.get(id);
		if (uploader != null) {
			return uploader.uploadFileChunk(chunkIndex, data);
		}
		return BigFileUploader.UPLOAD_REUPLOAD;
	}

	/**
	 * 每小时执行清理操作
	 */
	@Scheduled(cron = "0 0 */1 * * ?")
	public void scheduledCleanUploader() {
		try {
			cleanUploader(60);
		} catch (Exception e) {
			logger.info("清理Uploader失败", e);
		}
		// TODO 清理未上传成功的临时文件
	}

	public void cleanUploader(int minutes) {
		long time = System.currentTimeMillis() - minutes * 60 * 1000;
		Iterator<Map.Entry<String, BigFileUploader>> it = bigFileUploaderMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<String, BigFileUploader> entry = it.next();
			BigFileUploader uploader = entry.getValue();
			if (uploader.isCompleted() || uploader.getLastUpdateTime() < time) {
				it.remove();
			}
		}
	}

}
