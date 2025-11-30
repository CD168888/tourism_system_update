package org.example.springboot.service;


import io.micrometer.common.util.StringUtils;
import io.swagger.v3.oas.annotations.Operation;
import org.example.springboot.common.Result;
import org.example.springboot.enumClass.FileType;
import org.example.springboot.util.AliOssUtil;
import org.example.springboot.util.FileUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class FileService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FileService.class);

    @Autowired
    private AliOssUtil aliOssUtil;

    @Operation(summary = "文件上传")
    public Result<?> upLoad(MultipartFile file, FileType fileType) {
        if (com.baomidou.mybatisplus.core.toolkit.StringUtils.isBlank(file.getOriginalFilename())) {
            LOGGER.error("文件不存在");
            return Result.error("-1", "文件不存在！");
        }
        
        try {
            LOGGER.info("upload FILE to OSS:" + file.getOriginalFilename());
            String originalFilename = file.getOriginalFilename();
            // 截取原始文件名的后缀
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            // 构造新文件名称
            String objectName = UUID.randomUUID().toString() + extension;
            // 上传到阿里云OSS
            String filePath = aliOssUtil.upload(file.getBytes(), objectName);
            
            if (com.baomidou.mybatisplus.core.toolkit.StringUtils.isNotBlank(filePath)) {
                return Result.success(filePath);
            } else {
                return Result.error("-1", "文件上传失败");
            }
        } catch (Exception e) {
            LOGGER.error("文件上传到OSS失败: " + e.getMessage(), e);
            return Result.error("-1", "文件上传失败: " + e.getMessage());
        }
    }
    @DeleteMapping("/remove/{filename}")
    public Result<?> fileRemove(@PathVariable String filename){
<<<<<<< HEAD
        try {
            // 从OSS删除文件
            boolean res = aliOssUtil.delete(filename);
            return res ? Result.success() : Result.error("-1", "删除失败！");
        } catch (Exception e) {
            LOGGER.error("文件删除失败: " + e.getMessage(), e);
            return Result.error("-1", "删除失败: " + e.getMessage());
        }
=======
        String filePath="\\img\\"+filename;

        boolean res = FileUtil.deleteFile(filePath);

        return res? Result.success():Result.error("-1","删除失败！");

>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
    }

    public List<String> uploadMultiple(List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            LOGGER.error("没有文件上传");
            return null;
        }

        List<String> successPaths = new ArrayList<>();
<<<<<<< HEAD
        List<String> uploadedObjectNames = new ArrayList<>();
=======
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
        List<String> failedFiles = new ArrayList<>();

        for (MultipartFile file : files) {
            try {
                if (StringUtils.isEmpty(file.getOriginalFilename())) {
<<<<<<< HEAD
                    failedFiles.add("未知文件: 文件不存在");
                    continue;
                }
                
                LOGGER.info("upload FILE to OSS: " + file.getOriginalFilename());
                
                String originalFilename = file.getOriginalFilename();
                // 截取原始文件名的后缀
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                // 构造新文件名称
                String objectName = UUID.randomUUID().toString() + extension;
                
                // 上传到阿里云OSS
                String filePath = aliOssUtil.upload(file.getBytes(), objectName);
                
                if (com.baomidou.mybatisplus.core.toolkit.StringUtils.isNotBlank(filePath)) {
                    successPaths.add(filePath);
                    uploadedObjectNames.add(objectName);
                } else {
                    failedFiles.add(originalFilename + ": 文件上传失败");
                }
            } catch (Exception e) {
                LOGGER.error("文件上传到OSS时发生异常: " + e.getMessage(), e);
=======
                    failedFiles.add(file.getOriginalFilename() + ": 文件不存在");
                    continue;
                }
                LOGGER.info("upload FILE:" + file.getOriginalFilename());
                String path = FileUtil.saveFile(file,null,FileType.COMMON.getTypeName());
                if (StringUtils.isNotBlank(path)) {
                    successPaths.add(path);
                } else {
                    failedFiles.add(file.getOriginalFilename() + ": 文件上传失败");
                }
            } catch (Exception e) {
                LOGGER.error("文件上传时发生异常: " + e.getMessage(), e);
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
                failedFiles.add(file.getOriginalFilename() + ": 文件上传时发生异常");
            }
        }

        // 检查是否所有文件都成功上传
        if (!failedFiles.isEmpty()) {
<<<<<<< HEAD
            // 如果有文件上传失败，删除OSS上所有成功上传的文件
            for (String objectName : uploadedObjectNames) {
                try {
                    if (aliOssUtil.delete(objectName)) {
                        LOGGER.info("Deleted successfully uploaded file from OSS: " + objectName);
                    } else {
                        LOGGER.warn("Failed to delete file from OSS: " + objectName);
                    }
                } catch (Exception e) {
                    LOGGER.error("删除OSS文件时发生异常: " + e.getMessage(), e);
=======
            // 如果有文件上传失败，删除所有成功上传的文件
            for (String path : successPaths) {
                File uploadedFile = new File(path);
                if (uploadedFile.exists() && uploadedFile.isFile()) {
                    if (uploadedFile.delete()) {
                        LOGGER.info("Deleted successfully uploaded file: " + path);
                    } else {
                        LOGGER.warn("Failed to delete file: " + path);
                    }
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
                }
            }

            // 返回错误信息
<<<<<<< HEAD
            LOGGER.error("部分文件上传失败: " + String.join(", ", failedFiles));
=======
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
            return null;
        } else {
            // 如果全部成功，则只返回成功路径
            return successPaths;
        }
    }
}
