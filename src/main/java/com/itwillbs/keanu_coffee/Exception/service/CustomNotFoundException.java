package com.itwillbs.keanu_coffee.Exception.service;

//RuntimeException을 상속하면 예외를 던질 때 try-catch가 필수가 아님
public class CustomNotFoundException extends RuntimeException {

 public CustomNotFoundException() {
     super();
 }

 public CustomNotFoundException(String message) {
     super(message);
 }

 public CustomNotFoundException(String message, Throwable cause) {
     super(message, cause);
 }
}
