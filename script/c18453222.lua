--Trick$t@r Bloom
local m=18453222
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,1,1)
	local e1=MakeEff(c,"Qo","E")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DRAW)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function cm.pfil1(c,lc,sumtype,tp)
	return c:IsLevelBelow(2) and c:IsLinkSetCard(0x2e9)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1
	end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsLinkSummonable(nil)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.clim1(e,ep,tp)
	local c=e:GetHandler()
	return c:IsType(TYPE_TUNER) or tp==ep
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLinkSummonable(nil) then
		Duel.LinkSummon(tp,c,nil)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(1-tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function cm.nfil3(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsSetCard(0x2e9) and c:IsPreviousLocation(LSTN("M")) and bit.extract(zone,seq)>0
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.nfil3,1,nil,tp,c:GetLinkedZone())
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(1-tp,LSTN("H"),0)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,Duel.GetFieldGroupCount(1-tp,LSTN("H"),0)*200,REASON_EFFECT)
end