package com.paladin.uploader.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.paladin.framework.core.exception.BusinessException;
import com.paladin.framework.web.response.CommonResponse;

import io.swagger.annotations.Api;

@Api("用户认证模块")
@Controller
@RequestMapping("/")
public class IndexController {

	@Value("${paladin.access-key}")
	private String accessKey;

	@Value("${paladin.servlet-url}")
	private String servletUrl;

	@GetMapping(value = "/index")
	public Object main(String accessKey) {
		if (!this.accessKey.equals(accessKey)) {
			throw new BusinessException("没有权限");
		}
		return "/uploader/index";
	}

	@GetMapping(value = "/url")
	@ResponseBody
	public Object getServletUrl() {
		return CommonResponse.getSuccessResponse("", servletUrl);
	}
}
