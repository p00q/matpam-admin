package kr.co.matpam.admin.config;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

public class MySqlCleanupListener implements ServletContextListener {
    private static final Logger LOGGER = LoggerFactory.getLogger(MySqlCleanupListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // no-op
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == contextClassLoader) {
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (SQLException e) {
                    LOGGER.warn("Failed to deregister JDBC driver", e);
                }
            }
        }

        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Exception e) {
            LOGGER.warn("Failed to shutdown MySQL AbandonedConnectionCleanupThread", e);
        }
    }
}
