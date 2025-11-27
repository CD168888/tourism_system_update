package org.example.springboot.config;

import lombok.Data;
import org.example.springboot.util.AliOssUtil;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "aliyun.oss")
@Data
public class AliOssConfig {
    private String endpoint;
    private String accessKeyId;
    private String accessKeySecret;
    private String bucketName;

    @Bean
    public AliOssUtil aliOssUtil() {
        return new AliOssUtil(endpoint, accessKeyId, accessKeySecret, bucketName);
    }
}
