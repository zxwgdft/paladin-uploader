package com.paladin.uploader.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.paladin.framework.web.response.CommonResponse;
import com.paladin.uploader.core.BigFileUploaderContainer;

@Controller
@RequestMapping("/")
public class IndexController {

	@Value("${paladin.access-key}")
	private String accessKey;

	@Value("${paladin.servlet-url}")
	private String servletUrl;

	@Autowired
	private BigFileUploaderContainer bigFileUploaderContainer;

	@GetMapping(value = "/index")
	public Object main(String accessKey, Model model) {
		if (!this.accessKey.equals(accessKey)) {
			return CommonResponse.getNoPermissionResponse("没有权限");
		}
			
		model.addAttribute("servletUrl", servletUrl);
		model.addAttribute("accessKey", accessKey);
		return "/uploader/index";
	}

	@GetMapping(value = "/find/video")
	@ResponseBody
	public Object findVideos(String accessKey) {
		if (!this.accessKey.equals(accessKey)) {
			return CommonResponse.getNoPermissionResponse("没有权限");
		}
		return CommonResponse.getSuccessResponse(bigFileUploaderContainer.findAllVideo());
	}

	@GetMapping(value = "/remove/video")
	@ResponseBody
	public Object removeVideos(String pelativePath, String accessKey) {
		if (!this.accessKey.equals(accessKey)) {
			return CommonResponse.getNoPermissionResponse("没有权限");
		}
		return CommonResponse.getSuccessResponse(bigFileUploaderContainer.removeVideo(pelativePath));
	}
	
}
