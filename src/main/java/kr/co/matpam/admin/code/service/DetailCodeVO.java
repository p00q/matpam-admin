package kr.co.matpam.admin.code.service;

/**
 * 상세코드 VO
 */
public class DetailCodeVO {

    private String groupCode; // 그룹코드
    private String code; // 코드
    private String detailCode; // 상세코드
    private String detailCodeName; // 상세코드명
    private Integer sortOrder; // 정렬순서
    private String useYn; // 사용여부
    private String regDate; // 등록일시
    private String modDate; // 수정일시

    public String getGroupCode() {
        return groupCode;
    }

    public void setGroupCode(String groupCode) {
        this.groupCode = groupCode;
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

    public String getDetailCodeName() {
        return detailCodeName;
    }

    public void setDetailCodeName(String detailCodeName) {
        this.detailCodeName = detailCodeName;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
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
}
