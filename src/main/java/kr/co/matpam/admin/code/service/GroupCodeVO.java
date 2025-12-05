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
}
