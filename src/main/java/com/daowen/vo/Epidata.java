package com.daowen.vo;

import java.util.List;

public class Epidata {

    private String name;
    private int nowConfirm;
    private int confirm;
    private int dead;
    private int heal;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNowConfirm() {
        return nowConfirm;
    }

    public void setNowConfirm(int nowConfirm) {
        this.nowConfirm = nowConfirm;
    }

    public int getConfirm() {
        return confirm;
    }

    public void setConfirm(int confirm) {
        this.confirm = confirm;
    }

    public int getDead() {
        return dead;
    }

    public void setDead(int dead) {
        this.dead = dead;
    }

    public int getHeal() {
        return heal;
    }

    public void setHeal(int heal) {
        this.heal = heal;
    }

    private List<Epidata> children;

    public List<Epidata> getChildren() {
        return children;
    }

    public void setChildren(List<Epidata> children) {
        this.children = children;
    }
}
