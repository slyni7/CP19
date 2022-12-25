--에인덴 시무르그
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,aux.FBF(Card.IsSetCard,0x12d),1,99,s.pfil1)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetTR("M",0)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"C")
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetD(EFFECT_ANGEL_SIMORGH,0)
	WriteEff(e4,4,"C")
	WriteEff(e4,3,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","M")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_RECOVER)
	e5:SetCL(1)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetTR(0,"M")
	e6:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e6)
end
function s.oval1(c,sc,tc)
	if c==tc then
		return 4
	else
		return c:GetSynchroLevel(sc)
	end
end
function s.ofun1(sg,lv,sc)
	local res=false
	local tc=sg:GetFirst()
	while tc do
		if tc:IsSetCard(0x12d) then
			res=sg:CheckWithSumEqual(s.oval1,lv,#sg,#sg,sc,tc)
		end
		if res then
			break
		end
		tc=sg:GetNext()
	end
	return res
end
function s.op1(e,tg,ntg,sg,lv,sc,tp)
	local b1=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sc)
		and (not sc:IsCode(id) or sg:IsExists(Card.IsType,1,nil,TYPE_TUNER))
	local b2=sc:IsCode(id) and s.ofun1(sg,lv,sc)
	local res=b1 or b2
	return res,true
end
function s.pfil1(c,scard,sumtype,tp)
	return c:IsSetCard(0x12d,scard,sumtype,tp)
end
function s.tfil2(c,e,tp)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and s.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(s.tfil2,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GMGroup(aux.SimorghBanishFilter2,tp,"OH",0,nil,0)
	if chk==0 then
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(0),0)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(0)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(0),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=Duel.IsPlayerAffectedByEffect(tp,EFFECT_ANGEL_SIMORGH)
	local rg=Duel.GMGroup(aux.SimorghBanishFilterAngel2,tp,"OH","M",nil,0,tp)
	if chk==0 then
		return ae and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(0),0)
	end
	local ac=ae:GetHandler()
	if ac:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		ac:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(0)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(0),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tfil5(c)
	local te=c:CheckActivateEffect(false,false,false)
	return c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or (te and te:IsActivatable(tp,true,true)))
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil5,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,c:GetDefense())
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(tp,c:GetDefense(),REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil5,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local te=tc:CheckActivateEffect(false,false,false)
		local b1=tc:IsAbleToHand()
		local b2=te and te:IsActivatable(tp,true,true)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			Duel.HintActivation(te)
			e:SetActiveEffect(te)
			te:UseCountLimit(tp,1,true)
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			tc:CreateEffectRelation(te)
			if co then
				co(te,tp,eg,ep,ev,re,r,rp,1)
			end
			if tg then
				tg(te,tp,eg,ep,ev,re,r,rp,1)
			end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local etc=nil
			if g then
				etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			if op then
				op(te,tp,eg,ep,ev,re,r,rp)
			end
			tc:ReleaseEffectRelation(te)
			if g then
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
			e:SetActiveEffect(nil)
			e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RaiseEvent(tc,18452923,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end