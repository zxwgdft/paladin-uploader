package com.paladin.uploader.controller.upload;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.paladin.framework.web.response.CommonResponse;
import com.paladin.uploader.core.BigFileUploader;
import com.paladin.uploader.core.BigFileUploaderContainer;

@Controller
@RequestMapping("/upload")
public class WebUploadController {

	@Autowired
	private BigFileUploaderContainer bigFileUploaderContainer;

	@PostMapping("/check")
	@ResponseBody
	public Object uploadCheck(WebUploadParam param) {
		try {
			BigFileUploader uploader = bigFileUploaderContainer.getOrCreateUploader(param.getMd5(), param.getChunks(), param.getName());
			int status = uploader.isCompleted() ? BigFileUploader.UPLOAD_COMPLETED : BigFileUploader.UPLOAD_SUCCESS;
			return new CommonResponse(status, uploader.getUploadedChunk(), "");
		} catch (Exception e) {
			return new CommonResponse(BigFileUploader.UPLOAD_ERROR);
		}
	}

	@PostMapping("/chunk")
	@ResponseBody
	public Object uploadChunk(WebUploadParam param) {
		int result;
		try {
			result = bigFileUploaderContainer.uploadFileChunk(param.getMd5(), param.getChunk(), param.getFile().getBytes());
		} catch (IOException e) {
			result = BigFileUploader.UPLOAD_ERROR;
		}
		return CommonResponse.getSuccessResponse("", result);
	}

}
