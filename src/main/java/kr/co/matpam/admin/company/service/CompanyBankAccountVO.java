package kr.co.matpam.admin.company.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import java.util.Date;

/**
 * 업체 계좌정보 (tb_company_bank_account) VO
 */
public class CompanyBankAccountVO extends MatpamBaseVO {

    private Long bankAccountId;
    private Long companyId;
    private String bankName;
    private String accountNoEnc;
    private String accountHolder;
    private String isDefault;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private Long defaultCompanyGuard;

    // Getter & Setter
    public Long getBankAccountId() { return bankAccountId; }
    public void setBankAccountId(Long bankAccountId) { this.bankAccountId = bankAccountId; }

    public Long getCompanyId() { return companyId; }
    public void setCompanyId(Long companyId) { this.companyId = companyId; }

    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getAccountNoEnc() { return accountNoEnc; }
    public void setAccountNoEnc(String accountNoEnc) { this.accountNoEnc = accountNoEnc; }

    public String getAccountHolder() { return accountHolder; }
    public void setAccountHolder(String accountHolder) { this.accountHolder = accountHolder; }

    public String getIsDefault() { return isDefault; }
    public void setIsDefault(String isDefault) { this.isDefault = isDefault; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public Long getDefaultCompanyGuard() { return defaultCompanyGuard; }
    public void setDefaultCompanyGuard(Long defaultCompanyGuard) { this.defaultCompanyGuard = defaultCompanyGuard; }
}
