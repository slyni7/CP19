--ºÎÈ°ÀÇ ººÀ½
local m=18452878
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c,e,tp)
	return c:IsLevel(5,6) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		if not tc:IsCode(18452865) then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTarget(cm.otar11)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
		end
		if c:IsRelateToEffect(e) then
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,0,1,fid)
			local e3=MakeEff(c,"FTo","G")
			e3:SetCode(EVENT_TO_GRAVE)
			e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
			e3:SetCategory(CATEGORY_TODECK)
			e3:SetReset(RESET_EVENT+0x17a0000)
			e3:SetLabelObject(tc)
			e3:SetLabel(fid)
			e3:SetCondition(cm.ocon13)
			e3:SetCost(cm.ocost13)
			e3:SetTarget(cm.otar13)
			e3:SetOperation(cm.oop13)
			c:RegisterEffect(e3)
		end
	end
end
function cm.otar11(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH)
end
function cm.ocon13(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tc=e:GetLabel()
	return rp==1-tp and r&REASON_DESTROY>0 and eg:IsContains(tc) and tc:GetFlagEffectLabel(m)==fid
		and tc:GetPreviousControler()==tp and tc:IsPreviousLocation(LSTN("M"))
end
function cm.ocost13(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then
		return tc:IsAbleToRemoveAsCost()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function cm.otar13(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
	end
	Duel.SOI(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end