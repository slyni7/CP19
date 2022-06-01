--루틴 리피터
local m=18452802
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_MODULE),nil,1,5,nil)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tfil11(c,e,tp)
	return c:IsType(TYPE_MODULE) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IETarget(cm.tfil12,tp,"G",0,1,nil,c)
end
function cm.tfil12(c,ec)
	return c:GetType()&TYPE_EQUIP+TYPE_SPELL==TYPE_EQUIP+TYPE_SPELL and c:CheckEquipTarget(ec)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil11,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(tp,"S")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil11,tp,"G",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil12,tp,"G",0,1,1,nil,tc)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	if g:IsContains(tc) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		g:RemoveCard(tc)
		local ec=g:GetFirst()
		if ec then
			Duel.Equip(tp,ec,tc)
		end
	end
end
function cm.cfil2(c,tp,exc)
	local g=c:GetEquipGroup()
	local exg=g:Clone()
	exg:AddCard(c)
	exg:AddCard(exc)
	return #g>0 and Duel.IETarget(aux.TRUE,tp,"O","O",1,exg)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil2,1,c,tp,c)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil2,1,1,c,tp,c)
	Duel.Release(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc~=c
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"O","O",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,c)
	Duel.SOI(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local tc=Duel.GetFirstTarget()
	Duel.Equip(tp,tc,c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.oval21)
	tc:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function cm.oval21(e,c)
	return e:GetOwner()==c
end