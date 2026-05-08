<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.DataSource, org.springframework.web.context.support.WebApplicationContextUtils, org.springframework.context.ApplicationContext"%>
<%
    try {
        ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(config.getServletContext());
        DataSource ds = (DataSource) ac.getBean("dataSource");
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT login_id, password_hash, status FROM tb_user WHERE login_id = 'admin'");
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                out.println("Login ID: " + rs.getString("login_id"));
                out.println("Hash: " + rs.getString("password_hash"));
                out.println("Status: " + rs.getString("status"));
            } else {
                out.println("User 'admin' not found in tb_user.");
            }
        }
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
