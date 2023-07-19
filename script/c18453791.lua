--메타픽션의 수호자 에아토스
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(18452700,0))
	e1:SetValue(SUMMON_TYPE_DELIGHT)
	e1:SetLabel(0)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_DELIGHT_SUMMON)
	e2:SetLabel(10000)
	e2:SetCondition(s.con1)
	e2:SetOperation(s.op1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_REMOVE)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
s.CardType_Delight=true
s.custom_type=CUSTOMTYPE_DELIGHT
function s.con1(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Auxiliary.DelExtraFilter,tp,LOCATION_GRAVE,0,nil,nil,c)
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_DEL_MATERIAL)
	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
		return false
	end
	Duel.SetSelectedCard(fg)
	local gg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return gg==mg and #mg>=3
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local mg=Duel.GetMatchingGroup(Auxiliary.DelExtraFilter,tp,LOCATION_GRAVE,0,nil,nil,c)
	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_DEL_MATERIAL)
	Duel.SetSelectedCard(fg)
	local cancel=Duel.IsSummonCancelable()
	if cancel and not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	else
		c:SetMaterial(mg)
		Duel.Remove(mg,POS_FACEDOWN,REASON_MATERIAL)
		local tc=mg:GetFirst()
		while tc do
			Duel.RaiseSingleEvent(tc,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_DELIGHT,tp,tp,0)
			tc=mg:GetNext()
		end
		Duel.RaiseEvent(mg,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_DELIGHT,tp,tp,0)
		if e:GetLabel()==0 then
			c:SetStatus(STATUS_SPSUMMON_STEP,true)
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
			sg:AddCard(c)
		end
		aux.DelayByTurn(c,tp,#mg)
		if e:GetLabel()==10000 then
			Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
			if Duel.HintSpSummon then
				Duel.HintSpSummon(c)
			else
				Duel.Hint(HINT_CARD,0,c:GetCode())
			end
			c:SetStatus(STATUS_SPSUMMON_STEP,true)
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
			return
		end
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_DELIGHT)
end
function s.ofun31(c)
	local atk=c:GetTextAttack()
	if atk<0 then
		return 0
	end
	return atk
end
function s.ofun32(c)
	local def=c:GetTextDefense()
	if def<0 then
		return 0
	end
	return def
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local atk=mg:GetSum(s.ofun31)
	local def=mg:GetSum(s.ofun32)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
	end
	local fid=c:GetFieldID()
	local turn=Duel.GetTurnCount()
	local ct=1
	if Duel.GetCurrentPhase()==PHASE_END then
		ct=2
	end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,ct,fid)
	local e1=MakeEff(c,"FC")
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ccon41)
	e1:SetOperation(s.cop41)
	e1:SetLabel(turn+ct-2,fid)
	e1:SetReset(RESET_PHASE|PHASE_END,ct)
	Duel.RegisterEffect(e1,tp)
end
function s.ccon41(e,tp,eg,ep,ev,re,r,rp)
	local turn,fid=e:GetLabel()
	local c=e:GetHandler()
	return Duel.GetTurnCount()~=turn and c:GetFlagEffectLabel(id)==fid
end
function s.cop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ReturnToField(c)
	e:Reset()
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local gg1=Duel.GMGroup(nil,tp,0,"G",nil)
	local rg1=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"G",nil,POS_FACEDOWN)
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"E",nil,POS_FACEDOWN)
	local ct3=#rg3
	if ct3>6 then
		ct3=6
	end
	if chk==0 then
		return #gg1==#rg1 and (ct2==0 or #gg2==#rg2)
	end
	local rg=Group.CreateGroup()
	rg:Merge(rg1)
	rg:Merge(rg2)
	rg:Merge(rg3)
	local rct=#gg1+ct2+ct3
	Duel.SOI(0,CATEGORY_REMOVE,rg,rct,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gg1=Duel.GMGroup(nil,tp,0,"G",nil)
	local rg1=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"G",nil,POS_FACEDOWN)
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"E",nil,POS_FACEDOWN)
	local ct3=#rg3
	if ct3>6 then
		ct3=6
	end
	if #gg1==#rg1 and (ct2==0 or #gg2==#rg2) then
		local rg4=Group.CreateGroup()
		local rg5=rg3:RandomSelect(tp,ct3)
		rg4:Merge(rg1)
		rg4:Merge(rg2)
		rg4:Merge(rg5)
		Duel.DisableShuffleCheck()
		Duel.Remove(rg4,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local fid=c:GetFieldID()
		rg1:KeepAlive()
		rg2:KeepAlive()
		rg5:KeepAlive()
		local rc4=rg4:GetFirst()
		while rc4 do
			local pos=rc4:GetPreviousPosition()
			local loc=rc4:GetPreviousLocation()
			if pos&POS_FACEUP~=0 and loc==LOCATION_EXTRA then
				rc4:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid|0x80000000)
			else
				rc4:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid)
			end
			rc4=rg4:GetNext()
		end
		local e1=MakeEff(c,"FC")
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(s.ocon41)
		e1:SetOperation(s.oop41)
		e1:SetLabel(fid)
		e1:SetLabelObject({rg1,rg2,rg5})
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.onfil41(c,fid)
	return c:GetFlagEffectLabel(id)==fid or c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g1,g2,g5=table.unpack(e:GetLabelObject())
	return g1:IsExists(s.onfil41,1,nil,fid) or g2:IsExists(s.onfil41,1,nil,fid) or g5:IsExists(s.onfil41,1,nil,fid)
end
function s.oofil41(c,fid)
	return c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.oop41(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g1,g2,g5=table.unpack(e:GetLabelObject())
	Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
	local g3=Group.CreateGroup()
	g3:Merge(g2)
	g3:Merge(g5)
	local g4=g3:Filter(s.oofil41,nil,fid)
	g3:Sub(g4)
	Duel.SendtoDeck(g3,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoExtraP(g4,nil,REASON_EFFECT+REASON_RETURN)
	g1:DeleteGroup()
	g2:DeleteGroup()
	g5:DeleteGroup()
	e:Reset()
end