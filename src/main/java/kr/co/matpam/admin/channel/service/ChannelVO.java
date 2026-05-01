package kr.co.matpam.admin.channel.service;

import kr.co.matpam.common.service.MatpamBaseVO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.util.Date;

/**
 * 판매 채널 (tb_buyer_channel) VO
 */
@Getter
@Setter
@ToString
public class ChannelVO extends MatpamBaseVO {

    private Long channelId;
    private Long companyId;
    private Long platformId;
    private String channelName;
    private String apiKey;
    private String apiSecret;
    private String shopId;
    private String status;
    private Date createdAt;
    private Date updatedAt;

    // Join용 확장 필드
    private String platformName;
    private String companyName;
}
