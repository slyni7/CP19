--스퀘어위치 징커
local m=18452863
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,cm.pfun1,2,2,cm.pfil2,aux.Stringid(m,0),cm.pop1)
	local e1=MakeEff(c,"I","M")
	e1:SetCountLimit(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,xc)
	return c:IsXyzLevel(xc,1)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.pfil2(c)
	return c:IsFaceup() and c:IsSetCard(0x2d7) and not c:IsType(TYPE_XYZ)
end
function cm.pofil1(c)
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function cm.pop1(e,tp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.pofil1,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.pofil1,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	return true
end
cm.square_mana={0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfil11(c,tp)
	local te=c:CheckActivateEffect(false,false,false)
	local ft=Duel.GetLocCount(tp,"S")
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS
		and te and ft>0 and te:IsActivatable(tp)
		and not Duel.IEMCard(cm.tfil12,tp,"OG",0,1,nil,c:GetCode())
end
function cm.tfil12(c,code)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsCode(code)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if bit.band(tpe,TYPE_FIELD)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		Duel.HintActivation(te)
		e:SetActiveEffect(te)
		te:UseCountLimit(tp,1,true)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)<1 then
			tc:CancelToGrave(false)
		end
		tc:CreateEffectRelation(te)
		if co then
			co(te,tp,eg,ep,ev,re,r,rp,1)
		end
		if tg then
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=nil
		if g then
			etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op and not tc:IsDisabled() then
			op(te,tp,eg,ep,ev,re,r,rp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
				end
		end
		e:SetActiveEffect(nil)
		e:SetCategory(0)
		Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil21(c,e,tp)
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS and c:IsFaceup()
		and c.mana_list and Duel.IETarget(cm.tfil22,tp,"G",0,1,nil,e,tp,c)
end
function cm.tfil22(c,e,tp,tc)
	if c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
		local t=tc.mana_list
		for i=1,#t do
			if c:IsAttribute(tc.mana_list[i]) then
				return true
			end
			if c:IsHasExactSquareMana(tc.mana_list[i]) then
				return true
			end
		end
	end
	return false
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IEMCard(cm.tfil21,tp,"O",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil21,tp,"O",0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.STarget(tp,cm.tfil22,tp,"G",0,1,1,nil,e,tp,tc)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end