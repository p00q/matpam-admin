package kr.co.matpam.admin.financial.service.impl;

import java.util.Map;
import kr.co.matpam.admin.financial.service.CreditPolicyVO;
import kr.co.matpam.admin.financial.service.CreditLedgerVO;
import kr.co.matpam.admin.financial.service.AdvanceLedgerVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("b2bFinancialMapper")
public interface B2bFinancialMapper {
    
    CreditPolicyVO selectB2bCreditPolicy(Map<String, Object> param);
    
    void insertB2bCreditPolicy(CreditPolicyVO vo);
    
    void updateB2bCreditLimit(CreditPolicyVO vo);
    
    CreditLedgerVO selectLatestB2bCreditLedger(Map<String, Object> param);
    
    void insertB2bCreditLedger(CreditLedgerVO vo);
    
    AdvanceLedgerVO selectLatestB2bAdvanceLedger(Map<String, Object> param);
    
    void insertB2bAdvanceLedger(AdvanceLedgerVO vo);
}
