--¾Ù¸®½ºÅ©¸°
local m=18452980
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,cm.pfil1,2,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LSTN("HM"),0,Duel.Release,REASON_COST+REASON_MATERIAL)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if not c:IsCustomType(CUSTOMTYPE_SQUARE) then
		return false
	end
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then
		return true
	end
	local g=sg:Clone()
	g:AddCard(c)
	local st=fc.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_FIRE,0x0,ATTRIBUTE_WIND,0x0,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>1
	end
	Duel.Release(c,REASON_COST)
end
function cm.tfil21(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCustomType(CUSTOMTYPE_SQUARE) and not c:IsCode(m)
end
function cm.tfun2(g,st,mt)
	return aux.SquareCheck(g,st,mt,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.tfil21,tp,"G",0,nil,e,tp)
	local st=c:GetSquareMana()
	local mt={}
	if chkc then
		return false
	end
	if chk==0 then
		return g:CheckSubGroup(cm.tfun2,2,2,st,mt)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.tfun2,false,2,2,st,mt)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocCount(tp,"M")
	if #g<1 or ft<1 then
		return
	end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end