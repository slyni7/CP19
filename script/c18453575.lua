--진남불용청
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cfil1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost() and c:IsAttackAbove(1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil1,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetAttack())
	c:Type(TYPE_EFFECT+TYPE_MONSTER)
	c:Attribute(ATTRIBUTE_WATER)
	local eiat=Effect.IsActiveType
	function Effect.IsActiveType(effect,acttype)
		if effect==e then
			return acttype&TYPE_MONSTER>0
		end
		return eiat(effect,acttype)
	end
	Duel.SendtoGrave(g,REASON_COST)
	c:Type(TYPE_SPELL+TYPE_QUICKPLAY)
	c:Attribute(0)
	Effect.IsActiveType=eiat
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end