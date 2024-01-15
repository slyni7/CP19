--¿ø»öÈ«¿Á¡à·çºñ ÇÃ·¹¾î¡á
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCL(1,{id,1})
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
s.mana_list={ATTRIBUTE_FIRE}
function s.nfil11(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.nfil12(c)
	return c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_FIRE)
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
	return c:IsAttribute(ATTRIBUTE_FIRE)
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
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exc=c
	end
	if chkc then
		return chkc:IsOnField() and chkc~=exc
	end
	local dg=Duel.GMGroup(Card.IsCanBeEffectTarget,tp,"O","O",exc,e)
	local b1=Duel.CheckReleaseGroupCost(tp,s.cfil11,1,false,s.cfun1,nil,dg)
	local b2=Duel.IEMCard(s.nfil12,tp,"M",0,1,nil)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return b1 or b2
		else
			return Duel.IETarget(aux.TRUE,tp,"O","O",1,exc)
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,1,exc)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.tval11(e,c)
	return ATTRIBUTE_FIRE
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.tfil2(c)
	return c:IsCode(18453939) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"O",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,s.tfil2,tp,"O",0,1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end