--모노크로니클 릴리바이스
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetD(id,1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","F")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,0,EFFECT_COUNT_CODE_SINGLE)
	WriteEff(e3,3,"N")
	WriteEff(e3,2,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,2,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","F")
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetTR("H",0)
	e5:SetValue(SUMMON_TYPE_TRIBUTE)
	e5:SetD(id,3)
	e5:SetCondition(s.con5)
	e5:SetTarget(aux.FieldSummonProcTg(s.tar51,s.tar52))
	e5:SetOperation(s.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetD(id,2)
	WriteEff(e7,7,"C")
	c:RegisterEffect(e7)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.afil1)
end
function s.afil1(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_FIELD) and not rc:IsSetCard(0x2c6))
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x2c6,TYPES_TOKEN,2100,1200,7,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local e1=MakeEff(c,"F")
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.oval11)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=MakeEff(c,"FC","M")
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(s.oop11)
		token:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		token:RegisterEffect(e6)
		local e7=e2:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
		token:RegisterEffect(e7)
		local e8=e2:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
		token:RegisterEffect(e8)
		local e9=e2:Clone()
		--e9:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
		token:RegisterEffect(e9)
		local e10=e2:Clone()
		e10:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e10)
		local e11=e2:Clone()
		e11:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e11)
		Duel.SpecialSummonComplete()
	end
end
function s.oval11(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_FIELD) and not rc:IsSetCard(0x2c6)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetDefense()<800 then
		return
	end
	if c:IsImmuneToEffect(re) then
		return
	end
	if rp==tp then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) then
		c:ReleaseEffectRelation(re)
		local e1=MakeEff(c,"S")
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
	end
end
function s.tfil2(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetLocCount(tp,"M")>0
			--and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x2c6,TYPES_TOKEN,2100,1200,7,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
			and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SPOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local e1=MakeEff(c,"F")
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.oval11)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,2,2,nil)
			if #sg>0 and Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)>0 then
				Duel.SortDeckbottom(tp,tp,#sg)

	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x2c6,TYPES_TOKEN,2100,1200,7,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
		and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=MakeEff(c,"FC","M")
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(s.oop11)
		token:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		token:RegisterEffect(e6)
		local e7=e2:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
		token:RegisterEffect(e7)
		local e8=e2:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
		token:RegisterEffect(e8)
		local e9=e2:Clone()
		--e9:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
		token:RegisterEffect(e9)
		local e10=e2:Clone()
		e10:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e10)
		local e11=e2:Clone()
		e11:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e11)
		Duel.SpecialSummonComplete()
	end

			end
		end
	end
end
function s.nfil3(c,tp)
	return c:IsPreviousSetCard(0x2c6) and c:IsPreviousLocation(LSTN("M")) and
		c:GetPreviousControler()==tp and not c:IsType(TYPE_TOKEN)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(s.nfil3,nil,tp)
	return ct>0
end
function s.nfil5(c,tp)
	return c:IsCode(id+1) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.GetMZoneCount(tp,c)>0
end
function s.con5(e,c,minc)
	if c==nil then
		return true
	end
	if minc>1 then
		return false
	end
	local tp=c:GetControler()
	local mg=Duel.GMGroup(s.nfil5,tp,"M","M",nil,tp)
	return Duel.CheckTribute(c,1,1,mg) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x2c6,TYPES_TOKEN,2100,1200,7,RACE_PLANT,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)
end
function s.tar51(e,c)
	return c:IsSetCard(0x2c6)
end
function s.tar52(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GMGroup(s.nfil5,tp,"M","M",nil,tp)
	if Duel.GetLocCount(tp,"M")<=1 then
		mg:Match(Card.IsControler,nil,tp)
	end
	local sg=Duel.SelectTribute(tp,c,1,1,mg,nil,nil,true)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.op5(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then 
		return
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	sg:DeleteGroup()
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.oval11)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=MakeEff(c,"FC","M")
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(s.oop11)
		token:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_MODULE_MATERIAL)
		token:RegisterEffect(e6)
		local e7=e2:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_ORDER_MATERIAL)
		token:RegisterEffect(e7)
		local e8=e2:Clone()
		e8:SetCode(EFFECT_CANNOT_BE_SQUARE_MATERIAL)
		token:RegisterEffect(e8)
		local e9=e2:Clone()
		--e9:SetCode(EFFECT_CANNOT_BE_BEYOND_MATERIAL)
		token:RegisterEffect(e9)
		local e10=e2:Clone()
		e10:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e10)
		local e11=e2:Clone()
		e11:SetCode(EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
		token:RegisterEffect(e11)
		Duel.SpecialSummonComplete()

end
function s.cost7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,76859518)<1 and Duel.IsPlayerAffectedByEffect(tp,76859518)
	end
	Duel.Hint(HINT_CARD,0,76859518)
	Duel.RegisterFlagEffect(tp,76859518,RESET_PHASE+PHASE_END,0,1)
end