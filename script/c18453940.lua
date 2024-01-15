--원색의 연금석사
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.pfil1,s.pfun1,2,2,s.pfil2,aux.Stringid(id,0))
	local e0=MakeEff(c,"S")
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(18453939)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_MAIN_END)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.pfil1(c,xc)
	return c:IsXyzLevel(xc,3)
end
function s.pfun1(g)
	local st=s.square_mana
	return aux.IsFitSquare(g,st)
end
function s.pfil2(c)
	local st=s.square_mana
	return c:IsCode(18453939) and c:IsFaceup() and aux.IsFitSquare(Group.FromCards(c),st)
		--temp, not fully implemented(because of 0x0 mana)
		and (#c:GetSquareMana()>=#s.square_mana or
			(c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_WATER)
				and (c:GetLevel()>=#s.square_mana or c:GetRank()>=#s.square_mana)))
end
s.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_WATER,0x0,0x0}
s.custom_type=CUSTOMTYPE_SQUARE
function s.con2(e)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	return og:IsExists(Card.IsCode,1,nil,18453939)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfil3(c,e,tp,eg,ep,ev,re,r,rp)
	return (c:GetType()==TYPE_TRAP or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard("원색") and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,true)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		local g=Duel.GMGroup(s.cfil3,tp,"D",0,nil)
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	e:SetLabel(0)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GMGroup(s.cfil3,tp,"D",0,nil)
	local gct=g:GetClassCount(Card.GetCode)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,gct)
	Duel.SendtoGrave(sg,REASON_COST)
	local efftable={}
	local tgroup=Group.CreateGroup()
	while #sg>0 do
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		sg:RemoveCard(tc)
		local te=tc:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		local target=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):GetFirst()
		table.insert(efftable,{te,target})
		tgroup:AddCard(target)
		target:ReleaseEffectRelation(e)
	end
	e:SetLabelObject(efftable)
	for tc in aux.Next(tgroup) do
		tc:CreateEffectRelation(e)
	end
	Duel.ClearOperationInfo(0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local dgft=Duel.GetFirstTarget
	local lo=e:GetLabelObject()
	for _,tablet in ipairs(lo) do
		local eff,target=table.unpack(tablet)
		function Duel.GetFirstTarget()
			return target
		end
		local op=eff:GetOperation()
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	Duel.GetFirstTarget=dgft
end
