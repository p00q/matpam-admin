package kr.co.matpam.admin.settlement.service.impl;

import kr.co.matpam.admin.settlement.service.SettlementVO;
import kr.co.matpam.admin.settlement.service.SettlementLineVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("settlementMapper")
public interface SettlementMapper {
    
    void insertSettlement(SettlementVO vo);
    
    void insertSettlementLine(SettlementLineVO vo);
    
    void updateSettlementStatus(SettlementVO vo);
}
