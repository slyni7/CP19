--초정령 아쿠에리어
local m=18452776
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(0,1)
	e2:SetCondition(cm.con2)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e4,4,"N")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetCountLimit(1,m+1)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
end
function cm.nfil1(c,tp,xc)
	return ((c:IsFaceup() and c:IsLoc("M")) or
		(Duel.GetFlagEffect(tp,m)<1 and c:IsCode(40916023,218704) and c:IsLoc("H")))
		and c:IsCanBeXyzMaterial(xc) and (c:IsXyzLevel(xc,4) or c:IsRank(4))
end
function cm.nfun1(g,tp,xc)
	return g:FilterCount(Card.IsLoc,nil,"H")<2 and Duel.GetLocationCountFromEx(tp,tp,g,xc)>0
end
function cm.con1(e,c,og,mi,ma)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mic=2
	local mac=2
	if mi then
		mic=math.max(mic,mi)
		mac=math.max(mac,ma)
	end
	if mac<mic then
		return false
	end
	local mg=nil
	if og then
		mg=og:Filter(cm.nfil1,nil,tp,c)
	else
		mg=Duel.GMGroup(cm.nfil1,tp,"HM",0,nil,tp,c)
	end
	local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
		return false
	end
	Duel.SetSelectedCard(sg)
	local res=mg:CheckSubGroup(cm.nfun1,mic,mac,tp,c)
	return res
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c,og,mi,ma)
	if og and not mi then
		return true
	end
	local mic=2
	local mac=2
	if mi then
		if mi>mic then
			mic=mi
		end
		if ma>mac then
			mac=ma
		end
	end
	local mg=nil
	if og then
		mg=og:Filter(cm.nfil1,nil,tp,c)
	else
		mg=Duel.GMGroup(cm.nfil1,tp,"HM",0,nil,tp,c)
	end
	local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=mg:SelectSubGroup(tp,cm.nfun1,true,mic,mac,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		if g:FilterCount(Card.IsLoc,nil,"H")>0 then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
		return true
	else
		return false
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c,og,mi,ma)
	if og and not mi then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function cm.con2(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return #c:GetOverlayGroup()>0 and Duel.GetTurnPlayer()~=tp
end
function cm.val2(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsAttackPos() and rc:IsLoc("M")
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(18452787)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local oc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(oc)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDiscardDeck(tp,3)
	end
	Duel.SOI(0,CATEGORY_DECKDES,nil,0,tp,3)
	local oc=e:GetLabelObject()
	if oc:GetOriginalAttribute()&ATTRIBUTE_WATER>0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_SEARCH)
		Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
	end
end
function cm.ofil3(c)
	return c:IsCode(40916023,218704) and c:IsAbleToHand()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local oc=e:GetLabelObject()
	if oc:GetOriginalAttribute()&ATTRIBUTE_WATER>0 then
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SMCard(tp,cm.ofil3,tp,LSTN("D"),0,0,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(18452787)
end
function cm.tfil5(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("R") and cm.tfil5(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil5,tp,"R",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil5,tp,"R",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end