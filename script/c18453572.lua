--그리니치 슈퍼노바
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,nil,2,99,s.pfun1,s.pfun3)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","R")
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
s.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,
	ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,
	ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
s.custom_type=CUSTOMTYPE_SQUARE+CUSTOMTYPE_DELIGHT
function s.pfun1(g)
	local st=s.square_mana
	--[[Debug.Message(g:GetSum(s.pfun2,ATTRIBUTE_LIGHT)..","..g:GetSum(s.pfun2,ATTRIBUTE_WIND)..","..g:GetSum(s.pfun2,ATTRIBUTE_DARK))]]--
	return g:GetSum(s.pfun2,ATTRIBUTE_LIGHT)>=3
		and g:GetSum(s.pfun2,ATTRIBUTE_WIND)>=3
		and g:GetSum(s.pfun2,ATTRIBUTE_DARK)>=3
		and aux.IsFitSquare(g,st)
end
function s.pfun2(c,att)
	local val1=0
	if c:IsAttribute(att) then
		val1=c:GetLevel()
	end
	local val2=c:GetManaCount(att)
	return math.max(val1,val2)
end
function s.pfun3(g)
	local st=s.square_mana
	--[[Debug.Message(g:GetSum(s.pfun2,ATTRIBUTE_LIGHT)..","..g:GetSum(s.pfun2,ATTRIBUTE_WIND)..","..g:GetSum(s.pfun2,ATTRIBUTE_DARK))]]--
	return g:GetSum(s.pfun2,ATTRIBUTE_LIGHT)>=3
		and g:GetSum(s.pfun2,ATTRIBUTE_WIND)>=3
		and g:GetSum(s.pfun2,ATTRIBUTE_DARK)>=3
		and aux.IsFitSquare(g,st)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	Duel.ChangeChainOperation(ev,s.oco11(re))
end
function s.oco11(effect)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local e1=MakeEff(c,"FC")
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCL(1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				Duel.Hint(HINT_CARD,0,c:Code())
				effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
			end)
			Duel.RegisterEffect(e1,tp)
			e1:SetLabel(e:GetLabel())
			e1:SetLabelObject(e:GetLabelObject())
			aux.ChainDelay(e1)
		end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToExtraAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,3)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SOI(0,CATEGORY_HANDES,nil,0,tp,2)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,3,REASON_EFFECT)==3 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end
