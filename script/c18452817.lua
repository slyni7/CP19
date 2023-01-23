--급속장기동결장치
local m=18452817
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"SC")
	e1:SetCode(EVENT_DRAW)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
	local ge1=MakeEff(c,"F")
	ge1:SetCode(EFFECT_SSET_COST)
	ge1:SetTR(LOCATION_HAND,LOCATION_HAND)
	ge1:SetTarget(cm.gtar1)
	ge1:SetOperation(cm.gop1)
	Duel.RegisterEffect(ge1,0)
end
function cm.gtar1(e,c)
	return c:GetFlagEffect(m)>0
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckPhaseActivity() and Duel.GetCurrentPhase()==PHASE_MAIN1 then
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,m)<1 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,0,1)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+1)>0
end
function cm.tfil2(c,e,tp,mc)
	return c:IsCode(18452815) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,3000,2500,8,RACE_FAIRY,ATTRIBUTE_LIGHT)
			and Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil,e,tp,c)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then
		return
	end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,3000,2500,8,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"E",0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function cm.nfil3(c)
	return c:IsHasSquareMana(ATTRIBUTE_WATER) and c:IsFaceup()
end
function cm.con3(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(cm.nfil3,tp,"M",0,1,nil)
end