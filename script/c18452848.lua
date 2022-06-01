--헤븐 다크사이트 -나비-
local m=18452848
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","HM")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.nfil1(c)
	return c:IsFacedown() or not c:IsSetCard(0x2d9)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2d9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
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
	if Duel.GetLocCount(tp,"M")<2 or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfil2(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(1)
	if chk==0 then
		return (c:IsLoc("M") and Duel.CheckReleaseGroupEx(tp,cm.cfil2,1,nil,tp))
			or (c:IsLoc("H") and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0)
	end
	if c:IsLoc("M") then
		local g=Duel.SelectReleaseGroupEx(tp,cm.cfil2,1,1,nil,tp)
		Duel.Release(g,REASON_COST)
	else
		Duel.Release(c,REASON_COST)
	end
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2d9) and not c:IsCode(m)
		and (c:IsAbleToHand() or (Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local res=e:GetLabel()>0 or Duel.GetLocCount(tp,"M")>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IETarget(cm.tfil2,tp,"G",0,1,nil,e,tp)
	end
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_TOHAND,g,0,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
end
function cm.op2(e,tp,eg,ep,ev,r,er,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	local off=1
	local ops={}
	local opval={}
	if tc:IsAbleToHand() then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocCount(tp,"M")>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	elseif opval[op]==2 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end