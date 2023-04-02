--사일런트 머조리티: 1양
local m=18453750
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTR("M",0)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_RELEASE)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.square_mana={0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsFusionSetCard(0x2e0) and c:IsLevelAbove(3) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.pfil2(c,fc,sub,mg,sg)
	local st=c:GetSquareMana()
	if not st or #st==0 then
		return false
	end
	local res=true
	for i=1,#st do
		if st[i]~=0 then
			res=false
			break
		end
	end
	if not res then
		return false
	end
	if c:IsFusionSetCard(0x2e0) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.vfil1(c)
	return c:IsSetCard(0x2e0) or c:IsCode(18453084) or c:IsCode(18453099) or c:IsCode(18453100) or c:IsCode(18453752)
end
function cm.val1(e)
	local tp=e:GetHandlerPlayer()
	local ct=#Duel.GMGroup(cm.vfil1,tp,"G",0,nil)
	return ct*200
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsReleasableByEffect,tp,0,"O",1,nil)
	end
	Duel.SOI(0,CATEGORY_RELEASE,nil,1,1-tp,"O")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,Card.IsReleasableByEffect,tp,0,"O",1,1,nil)
	if #g>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end
function cm.cfil3(c,ft,tp)
	return c:IsSetCard(0x2e0) and (ft>0 or (c:IsControler(tp) and c:IsLoc("M") and c:GetSequence()<5))
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocCount(tp,"M")
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,cm.cfil3,1,true,nil,nil,ft,tp)
	end
	local g=Duel.SelectReleaseGroupCost(tp,cm.cfil3,1,1,true,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end