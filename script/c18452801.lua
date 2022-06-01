--릴리 에스컬레이션
local m=18452801
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.pfun1)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.pfun1(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_MODULE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(tp,"S")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,0,0,TYPE_MONSTER+TYPE_NORMAL,1600,1600,4,RACE_PLANT,RACE_WIND)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.ofun1(g,e,tp)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,true,false) and math.abs(fc:GetSequence()-nc:GetSequence())==1
		and g:FilterCount(cm.ofil1,nil)==2
end
function cm.ofil1(c)
	return c:GetType()&TYPE_SPELL+TYPE_EQUIP==TYPE_SPELL+TYPE_EQUIP
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LSTN("D"),0)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	if Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(tp,"S")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,0,0,TYPE_MONSTER+TYPE_NORMAL,1600,1600,4,RACE_PLANT,RACE_WIND)
		and g:CheckSubGroup(cm.ofun1,2,2,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.ofun1,false,2,2,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,true,false)
		local tc=tg:GetFirst()
		tc:AddMonsterAttribute(TYPE_NORMAL)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_RACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(RACE_PLANT)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(4)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_WIND)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(1600)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1600)
		tc:RegisterEffect(e5,true)
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		sg:Sub(tg)
		local ec=sg:GetFirst()
		Duel.Equip(tp,ec,tc)
		local e6=MakeEff(c,"S")
		e6:SetCode(EFFECT_EQUIP_LIMIT)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		e6:SetLabelObject(tc)
		e6:SetValue(cm.oval16)
		ec:RegisterEffect(e6)
	end
end
function cm.oval16(e,c)
	return e:GetLabelObject()==c
end