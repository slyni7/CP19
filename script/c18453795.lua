--'안다'고 "한다"에 닿지 못하는 세계에서
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfil1(c)
	return c:IsSetCard("메타픽션") and c:IsAbleToHand() and (c:IsFacedown() or c:IsLoc("D"))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tfil1,tp,LSTN("DR"),0,nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DR")
	Duel.SPOI(0,CATEGORY_REMOVE,nil,32,PLAYER_ALL,"DE")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tfil1,tp,LSTN("DR"),0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetD(id,0)
	e1:SetTR("HM",0)
	e1:SetTarget(s.otar11)
	Duel.RegisterEffect(e1,tp)
	local ct2=Duel.GetFieldGroupCount(tp,0,LSTN("D"))
	if ct2>10 then
		ct2=10
	end
	local gg2=Duel.GetDecktopGroup(1-tp,ct2)
	local rg2=gg2:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg3=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"E",nil,POS_FACEDOWN)
	local ct4=Duel.GetFieldGroupCount(tp,LSTN("D"),0)
	if ct4>10 then
		ct4=10
	end
	local gg4=Duel.GetDecktopGroup(tp,ct4)
	local rg4=gg4:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	local rg5=Duel.GMGroup(Card.IsAbleToRemove,tp,"E",0,nil,POS_FACEDOWN)
	if #rg2==10 and #rg3>=6 and #rg4==10 and #rg5>=6 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local rg6=Group.CreateGroup()
		local rg7=rg3:RandomSelect(tp,6)
		local rg8=rg5:RandomSelect(tp,6)
		rg6:Merge(rg2)
		rg6:Merge(rg7)
		rg6:Merge(rg4)
		rg6:Merge(rg8)
		Duel.DisableShuffleCheck()
		rg6:KeepAlive()
		Duel.Remove(rg6,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local fid=c:GetFieldID()
		local rc6=rg6:GetFirst()
		while rc6 do
			local pos=rc6:GetPreviousPosition()
			local loc=rc6:GetPreviousLocation()
			if pos&POS_FACEUP~=0 and loc==LOCATION_EXTRA then
				rc6:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid|0x80000000)
			else
				rc6:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid)
			end
			rc6=rg6:GetNext()
		end
		local e2=MakeEff(c,"FC")
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(s.ocon12)
		e2:SetOperation(s.oop12)
		e2:SetLabel(fid)
		e2:SetLabelObject(rg6)
		e2:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.otar11(e,c)
	return c:IsCode(18453790)
end
function s.onfil12(c,fid)
	return c:GetFlagEffectLabel(id)==fid or c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local rg=e:GetLabelObject()
	return rg:IsExists(s.onfil12,1,nil,fid)
end
function s.oofil12(c,fid)
	return c:GetFlagEffectLabel(id)==fid|0x80000000
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local rg=e:GetLabelObject()
	local ug=rg:Filter(s.oofil12,nil,fid)
	rg:Sub(ug)
	Duel.SendtoDeck(rg,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.SendtoExtraP(ug,nil,REASON_EFFECT+REASON_RETURN)
	rg:DeleteGroup()
	e:Reset()
end