--Trick$t@r Foxglove Witch
local m=18453226
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FBF(Card.IsLinkSetCard,0x2e9),2)
	local e1=MakeEff(c,"Qo","E")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	--damage
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCL(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	--special summon
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetCL(1,m+1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
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
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,LSTN("O"))>0
	end
	local d=Duel.GetFieldGroupCount(1-tp,LSTN("O"),0)*200
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetFieldGroupCount(1-tp,LSTN("O"),0)*200
	Duel.Damage(1-tp,d,REASON_EFFECT)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LSTN("M"))
end
function cm.tfil3(c,e,tp)
	return c:IsLinkBelow(2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"E",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
	local d=Duel.GetFieldGroupCount(1-tp,LSTN("O"),0)*200
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"E",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
		Duel.BreakEffect()
		local d=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*200
		Duel.Damage(1-tp,d,REASON_EFFECT)
	end
end