--원색수정□크리스탈 클리어■
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
s.mana_list={ATTRIBUTE_DARK}
function s.nfil11(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.nfil12(c)
	return c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_DARK)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil11,tp,"M",0,1,nil)
		or Duel.IEMCard(s.nfil12,tp,"M",0,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfil11(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.cfun1(sg,tp,exg,dg)
	local a=0
	for c in aux.Next(sg) do
		if dg:IsContains(c) then a=a+1 end
		for tc in aux.Next(c:GetEquipGroup()) do
			if dg:IsContains(tc) then a=a+1 end
		end
	end
	return #dg-a>=1
end
function s.tfil1(c,e,tp,chk)
	return (not chk or c:IsCanBeEffectTarget(e))
		and ((c:IsLoc("G") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0)
			or (c:IsLoc("M") and c:IsControlerCanBeChanged()))
		and (c:IsLoc("G") or c:IsControler(1-tp))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exc=c
	end
	if chkc then
		return chkc:IsLoc("MG") and chkc~=exc and s.tfil1(chkc,e,tp)
	end
	local dg=Duel.GMGroup(s.tfil1,tp,"OG","OG",exc,e,tp,true)
	local b1=Duel.CheckReleaseGroupCost(tp,s.cfil11,1,false,s.cfun1,nil,dg)
	local b2=Duel.IEMCard(s.nfil12,tp,"M",0,1,nil)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return b1 or b2
		else
			return Duel.IETarget(s.tfil1,tp,"G","MG",1,exc,e,tp)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)})
		if op==1 then
			local sg=Duel.SelectReleaseGroupCost(tp,s.cfil11,1,1,false,s.cfun1,nil,dg)
			Duel.Release(sg,REASON_COST)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tg=Duel.SMCard(tp,s.nfil12,tp,"M",0,1,1,nil)
			local sc=tg:GetFirst()
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.tval11)
			sc:RegisterEffect(e1)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.STarget(tp,s.tfil1,tp,"G","MG",1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLoc("G") then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		elseif tc:IsLoc("M") then
			e:SetCategory(CATEGORY_CONTROL)
			Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
		end
	end
end
function s.tval11(e,c)
	return ATTRIBUTE_DARK
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsLoc("G") then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsLoc("M") then
			Duel.GetControl(tc,tp)
		end
	end
end
function s.cfil2(c)
	return c:IsDiscardable() and c:IsSetCard("원색") and c:IsType(TYPE_QUICKPLAY)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
			and Duel.IEMCard(s.cfil2,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfli2,tp,"H",0,1,1,nil)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end