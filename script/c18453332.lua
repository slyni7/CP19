--Angel Beats! - 나오이 아야토
local m=18453332
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"FC","HS")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_RELEASE)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","S")
	e3:SetCode(EVENT_EQUIP)
	WriteEff(e3,3,"N")
	WriteEff(e3,2,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"SC")
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
end
function cm.ofil1(c)
	return c:IsSummonable(true,nil,1) and c:IsRace(RACE_FAIRY+RACE_FIEND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e then
		return
	end
	local c=e:GetHandler()
	if c:IsLoc("S") and c:GetEquipTarget()==nil then
		return
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetTR("H",0)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetCondition(cm.ocon11)
	e1:SetTarget(cm.otar11)
	e1:SetOperation(cm.oop11)
	Duel.RegisterEffect(e1,tp)
	local res=Duel.IEMCard(cm.ofil1,tp,"H",0,1,nil)
	e1:Reset()
	if res and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetTR("H",0)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		e1:SetCondition(cm.ocon11)
		e1:SetTarget(cm.otar11)
		e1:SetOperation(cm.oop11)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"H",0,1,1,nil)
		local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil,1)
		e1:Reset()
	end
end
function cm.onfil111(c)
	return c:IsRace(RACE_FAIRY+RACE_FIEND) and (c:IsLoc("H") or c:GetEquipTarget()~=nil)
end
function cm.onfil112(c,g,sc)
	if not c:IsReleasable() or g:IsContains(c) or c:IsHasEffect(EFFECT_EXTRA_RELEASE) then
		return false
	end
	local re=c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
	if re then
		local r,ct,f=rele:GetCountLimit()
		if r<1 then
			return false
		end
	else
		return false
	end
	local se={c:IsHasEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,te in ipairs(se) do
		if type(te:GetValue())=='function' then
			if te:GetValue(te,sc) then
				return false
			end
		else
			return false
		end
	end
	return true
end
function cm.onval11(c,sc,ma)
	local e3={c:IsHasEffect(EFFECT_TRIPLE_TRIBUTE)}
	if ma>2 then
		for _,te in ipairs(e3) do
			if type(te:GetValue())~='function' or te:GetValue(te,sc) then
				return 0x30001
			end
		end
	end
	local e2={c:IsHasEffect(EFFECT_DOUBLE_TRIBUTE)}
	for _,te in ipairs(e2) do
		if type(te:GetValue())~='function' or te:GetValue(te,sc) then
			return 0x20001
		end
	end
	return 1
end
function cm.onfil113(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function cm.onfun11(sg,c,tp)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=ma
	end
	if Duel.GetMZoneCount(tp,sg,tp)<1
		or sg:FilterCount(cm.onfil113,nil,tp)>1
		or sg:FilterCount(Card.IsLoc,nil,"H")>Duel.GetLocCount(tp,"S") then
		return false
	end
	local ct=#sg
	return sg:CheckWithSumEqual(cm.onval11,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(cm.onval11,ma,ct,ct,c,ma)
end
function cm.ocon11(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GMGroup(cm.onfil111,tp,"HS",0,c)
	g:Merge(exg)
	local opg=Duel.GMGroup(cm.onfil112,tp,0,"M",nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then
		mi=minc
	end
	if ma<mi then
		return false
	end
	local res=g:CheckSubGroup(cm.onfun11,1,ma,c,tp)
	return ma>0 and res
end
function cm.otar11(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi>0 and c:IsRace(RACE_FAIRY+RACE_FIEND)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GMGroup(cm.onfil111,tp,"HS",0,c)
	g:Merge(exg)
	local opg=Duel.GMGroup(cm.onfil112,tp,0,"M",nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then
		mi=1
	end
	local sg=g:SelectSubGroup(tp,cm.onfun11,false,1,ma,c,tp)
	local remc=sg:Filter(cm.onfil113,nil,tp):GetFirst()
	if remc then
		local rele=remc:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	local tg=sg:Filter(Card.IsLoc,nil,"HS")
	local tc=tg:GetFirst()
	local t={}
	while tc do
		if tc:IsLoc("H") then
			Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,false)
		elseif tc:IsLoc("S") then
			local e1=MakeEff(c,"SC","S")
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetTarget(cm.ootar111)
			tc:RegisterEffect(e1)
			table.insert(t,e1)
		end
		tc=tg:GetNext()
	end
	sg:Sub(tg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	for _,te in ipairs(t) do
		te:Reset()
		local ec=te:GetHandler()
		ec:SetStatus(STATUS_EFFECT_ENABLED,false)
	end
	tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		tc=tg:GetNext()
	end
	tg:KeepAlive()
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabelObject(tg)
	e2:SetOperation(cm.ooop112)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_SUMMON_NEGATED)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.ooop113)
	Duel.RegisterEffect(e3,tp)
	local e4=MakeEff(c,"FC")
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.ooop114)
	Duel.RegisterEffect(e4,tp)
	e:Reset()
end
function cm.ootar111(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	return true
end
function cm.ooop112(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if eg:IsContains(c) then
		local tc=g:GetFirst()
		while tc do
			tc:SetStatus(STATUS_ACTIVATE_DISABLED,false)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			Duel.Equip(tp,tc,c)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oooval1121)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		e:Reset()
	end
end
function cm.oooval1121(e,c)
	return e:GetOwner()==c
end
function cm.ooop113(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tg=te:GetLabelObject()
	if eg:IsContains(c) then
		Duel.Destroy(tg,REASON_RULE)
		te:Reset()
		e:Reset()
	end
end
function cm.ooop114(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local ee=te:GetLabelObject()
	if eg:IsContains(c) then
		ee:Reset()
		te:Reset()
		e:Reset()
	end
end
function cm.ofil2(c)
	return c:IsSetCard(0x2ef) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and not c:IsCode(m)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e then
		return
	end
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.ofil2,tp,"D",0,nil)
	if #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local dg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_RELEASE)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if not e then
		return
	end
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_ADVANCE) then
		return
	end
	local g=Duel.GMGroup(Card.IsControlerCanBeChanged,tp,0,"M",nil)
	if #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		Duel.GetControl(tc,tp)
	end
end
function cm.ofil5(c,tp)
	return c:IsRace(RACE_FAIRY+RACE_FIEND) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup()
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not e then
		return
	end
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_ADVANCE) then
		return
	end
	if eg:IsExists(cm.ofil5,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,3)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end