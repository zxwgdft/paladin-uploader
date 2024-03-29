package com.paladin.uploader.core;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.paladin.framework.core.exception.BusinessException;

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

	public List<FileVO> findAllVideo() {

		Path root = Paths.get(targetFolder);
		List<FileVO> videos = new ArrayList<>();

		try {
			Files.walkFileTree(root, new FileVisitor<Path>() {
				@Override
				public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
					return FileVisitResult.CONTINUE;
				}

				@Override
				public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {

					if (!file.toString().endsWith("temp")) {

						String pelativePath = file.toString();

						pelativePath = pelativePath.substring(targetFolder.length() - 1);

						FileVO video = new FileVO();
						video.setName(pelativePath);
						video.setPelativePath(pelativePath);
						video.setLastUpdateTime(Files.getLastModifiedTime(file).toMillis());
						video.setSize(Files.size(file));

						videos.add(video);
					}

					return FileVisitResult.CONTINUE;
				}

				@Override
				public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
					return FileVisitResult.CONTINUE;
				}

				@Override
				public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
					return FileVisitResult.CONTINUE;
				}
			});
		} catch (IOException e) {
			throw new BusinessException("查找文件失败");
		}

		return videos;
	}

	public boolean removeVideo(String pelativePath) {
		Path path = Paths.get(targetFolder + pelativePath);
		try {
			if (Files.deleteIfExists(path)) {
				scheduledCleanUploader();
				return true;
			}
			return false;
		} catch (IOException e) {
			throw new BusinessException("删除文件失败");
		}
	}

}
