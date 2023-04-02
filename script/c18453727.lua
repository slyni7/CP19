--시스토피아 디클레어러
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSequenceProcedure(c,nil,s.pfil1,1,99,s.pfil2,1,99)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_REMOVE)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function s.pfil1(re,rp)
	local rc=re:GetHandler()
	return rc:IsRace(RACE_FAIRY)
end
function s.pfil2(re,rp)
	local rc=re:GetHandler()
	return not rc:IsRace(RACE_FAIRY)
end
s.custom_type=CUSTOMTYPE_SEQUENCE
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.cfil1(c)
	return c:IsAbleToGraveAsCost() and (c:IsRace(RACE_FAIRY) or c:IsCustomType(CUSTOMTYPE_SEQUENCE))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil1,tp,LOCATION_HAND,0,0,1,c)
	g:AddCard(c)
	e:SetLabel(#g)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsAbleToRemove() then
		Duel.SOI(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b0=true
	local rc=re:GetHandler()
	local b1=rc:IsRelateToEffect(re) and rc:IsAbleToRemove()
	local sel=0
	local ct=e:GetLabel()
	for i=1,ct do
		local stable={}
		local dtable={}
		if b0 and (sel&0x1==0) then
			table.insert(stable,0x1)
			table.insert(dtable,aux.Stringid(id,0))
		end
		if b1 and (sel&0x2==0) then
			table.insert(stable,0x2)
			table.insert(dtable,aux.Stringid(id,1))
		end
		if #dtable==0 or (sel~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(dtable))+1
		sel=sel+stable[op]
	end
	if (sel&0x1==0x1) then
		Duel.ChangeChainOperation(ev,s.oco11(re))
	end
	if (sel&0x2==0x2) then
		Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCL(1)
		e2:SetLabelObject(rc)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCondition(s.ocon12)
		e2:SetOperation(s.oop12)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.oco11(effect)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local e1=MakeEff(c,"FC")
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCL(1)
			if Duel.GetCurrentPhase()==PHASE_END then
				local tid=Duel.GetTurnCount()
				e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					return tid~=Duel.GetTurnCount()
				end)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END)
			end
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
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetReasonEffect() and tc:GetReasonEffect():GetHandler()==e:GetHandler()
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.tfil2(c)
	return (c:IsSetCard("시스토피아") or c:IsSetCard("디클레어러")) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return aux.IsSequenceSummonable(tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HD")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	aux.SequenceSummon(tp)
end