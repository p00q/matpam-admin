<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.util.*, java.util.*"%>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/matpam_new?serverTimezone=Asia/Seoul&useUniCode=true&characterEncoding=utf8";
        conn = DriverManager.getConnection(url, "root", "root");
        stmt = conn.createStatement();
        
        out.println("<h3>Table: tb_group_code</h3>");
        rs = stmt.executeQuery("SELECT * FROM tb_group_code");
        out.println("<table border='1'><tr>");
        ResultSetMetaData md = rs.getMetaData();
        for(int i=1; i<=md.getColumnCount(); i++) out.println("<th>"+md.getColumnName(i)+"</th>");
        out.println("</tr>");
        while(rs.next()) {
            out.println("<tr>");
            for(int i=1; i<=md.getColumnCount(); i++) out.println("<td>"+rs.getString(i)+"</td>");
            out.println("</tr>");
        }
        out.println("</table>");

        out.println("<h3>tb_group_code Content Check</h3>");
        rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_group_code");
        if(rs.next()) out.println("Total Group Codes: " + rs.getInt(1) + "<br>");

        rs = stmt.executeQuery("SELECT * FROM tb_group_code LIMIT 5");
        md = rs.getMetaData();
        out.println("<table border='1'><tr>");
        for(int i=1; i<=md.getColumnCount(); i++) out.println("<th>"+md.getColumnName(i)+"</th>");
        out.println("</tr>");
        while(rs.next()) {
            out.println("<tr>");
            for(int i=1; i<=md.getColumnCount(); i++) out.println("<td>"+rs.getString(i)+"</td>");
            out.println("</tr>");
        }
        out.println("</table>");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if(rs != null) rs.close();
        if(stmt != null) stmt.close();
        if(conn != null) conn.close();
    }
%>
