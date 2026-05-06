package kr.co.matpam.admin.financial.service.impl;

import java.math.BigDecimal;
import java.util.Map;
import kr.co.matpam.admin.financial.service.CreditPolicyVO;
import kr.co.matpam.admin.financial.service.CreditLedgerVO;
import kr.co.matpam.admin.financial.service.AdvanceLedgerVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("financialMapper")
public interface FinancialMapper {
    
    CreditPolicyVO selectCreditPolicy(Map<String, Object> param);
    
    void insertCreditPolicy(CreditPolicyVO vo);
    
    void updateCreditLimit(CreditPolicyVO vo);
    
    CreditLedgerVO selectLatestCreditLedger(Map<String, Object> param);
    
    void insertCreditLedger(CreditLedgerVO vo);
    
    AdvanceLedgerVO selectLatestAdvanceLedger(Map<String, Object> param);
    
    void insertAdvanceLedger(AdvanceLedgerVO vo);
}
