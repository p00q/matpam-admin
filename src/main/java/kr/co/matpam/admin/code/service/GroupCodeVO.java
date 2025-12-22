package kr.co.matpam.admin.code.service;

/**
 * 그룹코드 VO
 */
public class GroupCodeVO {

    private String groupCode; // 그룹코드
    private String groupCodeName; // 그룹코드명
    private String useYn; // 사용여부
    private String regDate; // 등록일시
    private String modDate; // 수정일시

    // 검색 필터용 필드
    private String code; // 코드 필터
    private String detailCode; // 상세코드 필터

    public String getGroupCode() {
        return groupCode;
    }

    public void setGroupCode(String groupCode) {
        this.groupCode = groupCode;
    }

    public String getGroupCodeName() {
        return groupCodeName;
    }

    public void setGroupCodeName(String groupCodeName) {
        this.groupCodeName = groupCodeName;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getModDate() {
        return modDate;
    }

    public void setModDate(String modDate) {
        this.modDate = modDate;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDetailCode() {
        return detailCode;
    }

    public void setDetailCode(String detailCode) {
        this.detailCode = detailCode;
    }
}
