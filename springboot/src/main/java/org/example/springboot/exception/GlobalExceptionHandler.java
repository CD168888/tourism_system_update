package org.example.springboot.exception;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.example.springboot.common.Result;
import org.example.springboot.common.ResultCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@RestControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 处理自定义异常
     */
    @ExceptionHandler(ServiceException.class)
    public Result<?> handleServiceException(ServiceException e, HttpServletRequest request) {
        // 如果是 SSE 请求，不拦截异常，让其自然传播
        if (isSSERequest(request)) {
            throw e;
        }
        log.error(e.getMessage(), e);
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 参数验证异常
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<?> handleMethodArgumentNotValidException(MethodArgumentNotValidException e, HttpServletRequest request) {
        // 如果是 SSE 请求，不拦截异常，让其自然传播
        if (isSSERequest(request)) {
            throw new RuntimeException(e);
        }
        
        log.error(e.getMessage(), e);
        String message = e.getBindingResult().getFieldError().getDefaultMessage();
        return Result.error(ResultCode.VALIDATE_FAILED.getCode(), message);
    }

    /**
     * 约束违反异常
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public Result<?> handleConstraintViolationException(ConstraintViolationException e, HttpServletRequest request) {
        // 如果是 SSE 请求，不拦截异常，让其自然传播
        if (isSSERequest(request)) {
            throw e;
        }
        
        log.error(e.getMessage(), e);
        return Result.error(ResultCode.VALIDATE_FAILED.getCode(), e.getMessage());
    }

    /**
     * 处理静态资源未找到异常
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public Result<?> handleNoResourceFoundException(NoResourceFoundException e, HttpServletRequest request) {
        // 如果是 SSE 请求，不拦截异常，让其自然传播
        if (isSSERequest(request)) {
            throw new RuntimeException(e);
        }
        
        // 只记录debug级别日志
        if (log.isDebugEnabled()) {
            log.debug("静态资源未找到: {}", e.getMessage());
        }

        return Result.error(ResultCode.VALIDATE_FAILED.getCode(), "资源未找到");
    }

    /**
     * 处理其他异常
     */
    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e, HttpServletRequest request) {
        // 如果是 SSE 请求，不拦截异常，让其自然传播
        if (isSSERequest(request)) {
            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            }
            throw new RuntimeException(e);
        }
        log.error(e.getMessage(), e);
        return Result.error(ResultCode.SYSTEM_ERROR.getCode(), "系统错误");
    }

    /**
     * 判断是否为 SSE 请求
     */
    private boolean isSSERequest(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        String requestURI = request.getRequestURI();
        // 检查 Accept 头是否包含 text/event-stream，或者请求路径是否为 SSE 接口
        return (accept != null && accept.contains(MediaType.TEXT_EVENT_STREAM_VALUE)) ||
               (requestURI != null && requestURI.contains("/chat/ai/memory"));
    }
} 