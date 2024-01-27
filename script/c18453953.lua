--XX(익스트림 엑시즈) [로큰롤]
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCL(1,id)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.afil1)
end
function s.afil1(c)
	return c:IsType(TYPE_XYZ) or not c:IsLocation(LOCATION_EXTRA)
end
function s.nfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsPublic() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.ConfirmCards(1-tp,c)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.ctar11)
	Duel.RegisterEffect(e1,tp)
end
function s.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function s.tfil11(c,e,tp,mc)
	if not (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id) and c:IsSetCard("XX(익스트림 엑시즈)")) then
		return false
	end
	local efftable={}
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_ROCK)
	c:RegisterEffect(e1)
	table.insert(efftable,e1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(RACE_ROCK)
	mc:RegisterEffect(e1)
	table.insert(efftable,e1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e1)
	table.insert(efftable,e1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WIND)
	mc:RegisterEffect(e1)
	table.insert(efftable,e1)
	local le1=MakeEff(c,"S")
	le1:SetCode(EFFECT_CHANGE_LEVEL)
	le1:SetValue(3)
	c:RegisterEffect(le1)
	local le2=MakeEff(c,"S")
	le2:SetCode(EFFECT_CHANGE_LEVEL)
	le2:SetValue(3)
	mc:RegisterEffect(le2)
	local res=Duel.IEMCard(s.tfil12,tp,"E",0,1,nil,Group.FromCards(c,mc),tp)
	if not res and Duel.GetTurnPlayer()~=tp then
		le1:Reset()
		le2:Reset()
		local lv=c:GetLevel()+mc:GetLevel()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		c:RegisterEffect(e1)
		table.insert(efftable,e1)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		mc:RegisterEffect(e1)
		table.insert(efftable,e1)
		res=Duel.IEMCard(s.tfil12,tp,"E",0,1,nil,Group.FromCards(c,mc),tp)
	else
		le1:Reset()
		le2:Reset()
	end
	for _,te in ipairs(efftable) do
		te:Reset()
	end
	return res
end
function s.tfil12(c,mg,tp)
	return Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsXyzSummonable(nil,mg)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IEMCard(s.tfil11,tp,"D",0,1,nil,e,tp,c)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,3,tp,"DE")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e)
		and Duel.GetLocCount(tp,"M")>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IEMCard(s.tfil11,tp,"D",0,1,nil,e,tp,c)) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil11,tp,"D",0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(Group.FromCards(c,tc),0,tp,tp,false,false,POS_FACEUP)>0 then
		local mg=Group.FromCards(c,tc)
		for mc in aux.Next(mg) do
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(RACE_ROCK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(ATTRIBUTE_WIND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_DISABLE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(RESET_TURN_SET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			mc:RegisterEffect(e1)
		end
		local b1=true
		local lv=c:GetLevel()+tc:GetLevel()
		local le1=MakeEff(c,"S")
		le1:SetCode(EFFECT_CHANGE_LEVEL)
		le1:SetValue(lv)
		c:RegisterEffect(le1)
		local le2=MakeEff(c,"S")
		le2:SetCode(EFFECT_CHANGE_LEVEL)
		le2:SetValue(lv)
		tc:RegisterEffect(le2)
		local b2=Duel.GetTurnPlayer()~=tp and Duel.IEMCard(s.tfil12,tp,"E",0,1,nil,mg,tp)
		le1:Reset()
		le2:Reset()
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,0)},
			{b2,aux.Stringid(id,1)})
		if op==1 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(3)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(3)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif op==2 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local xyzg=Duel.GMGroup(s.tfil12,tp,"E",0,nil,mg,tp)
		if #xyzg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,nil,mg)
		end
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	e1:SetCondition(s.ocon31)
	e1:SetTarget(s.otar31)
	e1:SetOperation(s.oop31)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function s.ocon31(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.otfil31(c)
	return c:IsCode(id) and c:IsAbleToHand()
end
function s.otar31(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.otfil31,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.otfil31,tp,"D",0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end