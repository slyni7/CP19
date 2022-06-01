--매지컬 미니햇
local m=18453026
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c)
	return c:GetSequence()<5 and not c:IsType(TYPE_TOKEN+TYPE_LINK)
end
function cm.tfil12(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN_DEFENSE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEDOWN_DEFENSE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IETarget(cm.tfil11,tp,"M",0,1,nil)
			and Duel.GetLocCount(tp,"M")>1
			and Duel.IEMCard(cm.tfil12,tp,"D",0,2,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.STarget(tp,cm.tfil11,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<2 then
		return
	end
	local g=Duel.GMGroup(cm.tfil12,tp,"D",0,nil,e,tp)
	if #g<2 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if tc:IsFaceup() then
		if EFFECT_DEVINE_LIGHT and tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
	local sc=sg:GetFirst()
	local fid=c:GetFieldID()
	while sc do
		local e1=MakeEff(sc,"S")
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		sc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		sc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		sc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		sc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		sc:RegisterEffect(e5,true)
		sc:RegisterFlagEffect(m,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_BATTLE,0,1,fid)
		sc:SetStatus(STATUS_NO_LEVEL,true)
		sc=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
	sg:AddCard(tc)
	Duel.ShuffleSetCard(sg)
	local chain=Duel.GetCurrentChain()
	if chain>0 then
		for i=chain-1,1,-1 do
			local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if ce:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				local cp,cg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_CARDS)
				local cc=ce:GetHandler()
				if cg and cg:IsContains(tc) and cp~=tp and not cc:IsImmuneToEffect(e) then
					Duel.Hint(HINT_CARD,0,ce:GetCode())
					Duel.HintSelection(Group.FromCards(cc))
					local ig=cg:Clone()
					ig:RemoveCard(tc)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local newg=sg:Select(cp,1,1,nil)
					local newc=newg:GetFirst()
					ig:AddCard(newc)
					Duel.ChangeTargetCard(i,ig)
				end
			end
		end
	end
	sg:RemoveCard(tc)
	sg:KeepAlive()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetLabel(fid)
	e6:SetLabelObject(sg)
	e6:SetOperation(cm.oop16(Duel.GetTurnCount(),Duel.GetCurrentPhase()))
	Duel.RegisterEffect(e6,tp)
end
function cm.oofil16(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.oop16(turn,phase)
	return
		function(e,tp,eg,ep,ev,re,r,rp)
			if Duel.GetTurnCount()==turn and Duel.GetCurrentPhase()==phase then
				return
			end
			local g=e:GetLabelObject()
			local fid=e:GetLabel()
			local tg=g:Filter(cm.oofil16,nil,fid)
			g:DeleteGroup()
			Duel.Destroy(tg,REASON_EFFECT)
			local tg2=tg:Filter(cm.oofil16,nil,fid)
			Duel.SendtoGrave(tg2,REASON_EFFECT)
			e:Reset()
		end
end