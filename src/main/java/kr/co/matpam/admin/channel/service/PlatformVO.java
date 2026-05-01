package kr.co.matpam.admin.channel.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 플랫폼 마스터 (tb_platform) VO
 */
@Getter
@Setter
@ToString
public class PlatformVO extends MatpamBaseVO {

    private Long platformId;
    private String platformName;
    private String platformCode;
    private String status;
}
