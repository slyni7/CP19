--정령력 폭주
local m=18452788
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.nfil1(c)
	return c:IsCode(18452784) and c:IsFaceup()
end
function cm.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(cm.nfil1,tp,"OR",0,1,nil)
end
function cm.tfil2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE)
		and (((c:IsLevel(4) or c:IsRank(4)) and c:IsSetCard("정령") and not c:IsSummonableCard())
		or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665,18452771))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"R",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GMGroup(cm.tfil2,tp,"R",0,nil,e,tp)
	local ft=Duel.GetLocCount(tp,"M")
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ft)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocCount(tp,"M")
	if ft<1 then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil31(c,tp)
	return c:IsSetCard("초정령") and c:IsType(TYPE_XYZ) and c:IsFaceup()
		and Duel.IEMCard(cm.tfil32,tp,"D",0,1,nil,c:GetAttribute())
end
function cm.tfil32(c,att)
	return c:GetAttribute()&att>0
		and ((c:IsLevel(4) and c:IsSetCard("정령") and not c:IsSummonableCard())
			or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil31,tp,"M",0,1,nil,tp)
	end
end
function cm.ofil31(c,g)
	return g:IsExists(cm.ofil32,1,nil,c:GetAttribute())
		and ((c:IsLevel(4) and c:IsSetCard("정령") and not c:IsSummonableCard())
			or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665))
end
function cm.ofil32(c,att)
	return c:GetAttribute()&att>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil31,tp,"M",0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,6)
	local dg=Duel.GMGroup(cm.ofil31,tp,"D",0,nil,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local og=dg:SelectSubGroup(tp,aux.dabcheck,false,#sg,#sg)
	local tc=sg:GetFirst()
	while tc do
		local oc=og:Filter(Card.IsAttribute,nil,tc:GetAttribute()):GetFirst()
		Duel.Overlay(tc,Group.FromCards(oc))
		og:RemoveCard(oc)
		tc=sg:GetNext()
	end
end