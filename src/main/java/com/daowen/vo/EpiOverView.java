package com.daowen.vo;

/**
 * 疫情总体视图
 */
public class EpiOverView {

    /**
     * 境外输入
     */
    private int input;
    /**
     * 境外新增
     */
    private int inputIncrease;

    /**
     * 无症状感染者
     */
    private int noSymptom;
    /**
     * 无症状新增
     */

    private int noSymptomIncrease;


    /**
     * 现有确诊人数
     */
    private int nowConfirm;

    /**
     * 新增现有确证新增
     */
    private int nowConfirmIncrease;


    /**
     * 确证人数
     */
    private int confirm;

    /**
     * 新增确证人数
     */
    private int confirmIncrease;

    /**
     *死亡人数
     */
    private  int dead;

    /**
     * 死亡新增人数
     */
    private int deadIncrease;


    /**
     * 治愈人数
     */
    private int heal;

    /**
     * 自愈新增
     */
    private int healIncrease;


    public int getInput() {
        return input;
    }

    public void setInput(int input) {
        this.input = input;
    }

    public int getInputIncrease() {
        return inputIncrease;
    }

    public void setInputIncrease(int inputIncrease) {
        this.inputIncrease = inputIncrease;
    }

    public int getNoSymptom() {
        return noSymptom;
    }

    public void setNoSymptom(int noSymptom) {
        this.noSymptom = noSymptom;
    }

    public int getNoSymptomIncrease() {
        return noSymptomIncrease;
    }

    public void setNoSymptomIncrease(int noSymptomIncrease) {
        this.noSymptomIncrease = noSymptomIncrease;
    }

    public int getNowConfirm() {
        return nowConfirm;
    }

    public void setNowConfirm(int nowConfirm) {
        this.nowConfirm = nowConfirm;
    }

    public int getNowConfirmIncrease() {
        return nowConfirmIncrease;
    }

    public void setNowConfirmIncrease(int nowConfirmIncrease) {
        this.nowConfirmIncrease = nowConfirmIncrease;
    }

    public int getConfirm() {
        return confirm;
    }

    public void setConfirm(int confirm) {
        this.confirm = confirm;
    }

    public int getConfirmIncrease() {
        return confirmIncrease;
    }

    public void setConfirmIncrease(int confirmIncrease) {
        this.confirmIncrease = confirmIncrease;
    }

    public int getDead() {
        return dead;
    }

    public void setDead(int dead) {
        this.dead = dead;
    }

    public int getDeadIncrease() {
        return deadIncrease;
    }

    public void setDeadIncrease(int deadIncrease) {
        this.deadIncrease = deadIncrease;
    }

    public int getHeal() {
        return heal;
    }

    public void setHeal(int heal) {
        this.heal = heal;
    }

    public int getHealIncrease() {
        return healIncrease;
    }

    public void setHealIncrease(int healIncrease) {
        this.healIncrease = healIncrease;
    }

    @Override
    public String toString() {
        return "EpiOverView{" +
                "input=" + input +
                ", inputIncrease=" + inputIncrease +
                ", noSymptom=" + noSymptom +
                ", noSymptomIncrease=" + noSymptomIncrease +
                ", nowConfirm=" + nowConfirm +
                ", nowConfirmIncrease=" + nowConfirmIncrease +
                ", confirm=" + confirm +
                ", confirmIncrease=" + confirmIncrease +
                ", dead=" + dead +
                ", deadIncrease=" + deadIncrease +
                ", heal=" + heal +
                ", healIncrease=" + healIncrease +
                '}';
    }
}
