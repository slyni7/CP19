--TT(트리플 트리니티)#2 - 블링크
local m=18453024
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.afil1)
end
function cm.afil1(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (loc&LOCATION_ONFIELD>0 and not rc:IsSetCard(0x2df))
end
function cm.nfil1(c)
	return c:IsFaceup() and not c:IsSetCard(0x2df)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)<1
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetValue(cm.cval11)
	Duel.RegisterEffect(e1,tp)
end
function cm.cval11(e,re,tp)
	local rc=re:GetHandler()
	return (rc:IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and not rc:IsSetCard(0x2df)
end
function cm.tfil1(c,e,tp)
	return c:IsCode(18453027) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,"HD")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end