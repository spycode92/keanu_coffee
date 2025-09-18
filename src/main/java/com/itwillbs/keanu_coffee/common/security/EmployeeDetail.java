package com.itwillbs.keanu_coffee.common.security;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.itwillbs.keanu_coffee.admin.dto.RoleDTO;
import com.itwillbs.keanu_coffee.common.dto.CommonCodeDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@ToString
@Getter
public class EmployeeDetail implements UserDetails {
	
	private static final long serialVersionUID = 1L;
	private String empNo;
	private Integer empIdx;
	private String empPassword;
	private String empName;
	private String empStatus;
	private RoleDTO role;
	private List<CommonCodeDTO> commonCodes;
	
	// UserDetails 인터페이스의 추상메서드 오버라이딩
	// ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return commonCodes.stream()
				.map(commonCode -> new SimpleGrantedAuthority(commonCode.getCommonCode()))
				.collect(Collectors.toList());
	}

	@Override
	public String getPassword() {
		// TODO Auto-generated method stub
		return empPassword;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return empNo;
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return "재직".equals(empStatus);
	}

}
