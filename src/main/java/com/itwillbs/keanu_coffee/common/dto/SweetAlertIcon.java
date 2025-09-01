package com.itwillbs.keanu_coffee.common.dto;

public enum SweetAlertIcon {
	INFO("info"),
    ERROR("error"),
    WARNING("warning"),
    SUCCESS("success"),
	QUESTION("question");

    private final String value;

    SweetAlertIcon(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
