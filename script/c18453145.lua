--도로보네코 골드
local m=18453145
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,1,1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_CAPABLE_CHANGE_POSITION)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetTR("S","S")
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.pfil1(c)
	return c:IsLinkSetCard(0x2e4) and not c:IsLinkCode(m)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable(true)
	end
	Duel.SSet(tp,c)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SOI(0,CATEGORY_TODECK,nil,1,tp,"H")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,1,1,nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("S") and c:IsFacedown() and c:GetType()==TYPE_SPELL
end
function cm.tfil3(c)
	return c:IsSetCard(0x2e4) and c:IsType(TYPE_MONSTER) and c:IsSSetable(true)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	e:GetHandler():CancelToGrave(false)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end