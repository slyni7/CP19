--[ hololive Myth ]
local m=99970691
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=MakeEff(c,"I","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)

	--서치+샐비지
	local e3=MakeEff(c,"STf")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
	--표시 형식 변경
	local e4=MakeEff(c,"Qo","M")
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCL(1)
	e4:SetCondition(YuL.Bphase(2))
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)

end

--특수 소환
function cm.cfil(c,ft,tp)
	return c:IsFacedown() and (ft>0 or c:IsInMainMZone(tp))
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp) end
	local g=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft,tp)
	local rel=0
	if g:GetFirst():IsControler(1-tp) then rel=1 end
	Duel.Release(g,REASON_COST)
	e:SetLabel(rel)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local rel=e:GetLabel()
		if rel==0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetD(m,1)
				e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e2:SetValue(LOCATION_DECKBOT)
				e2:SetReset(RESET_EVENT+0x47e0000)
				c:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,nil)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,4,nil)
end

--서치 + 샐비지
function cm.thfilter(c)
	return c:IsCode(99970696) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--표시 형식 변경
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		local fid=c:GetFieldID()
		g:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetLabelObject(tc)
		e4:SetLabel(fid)
		e4:SetTarget(cm.op4tar)
		c:RegisterEffect(e4)
	end
end
function cm.op4tar(e,c)
   local fid=e:GetLabel()
   local tc=e:GetLabelObject()
   return tc==c and c:GetFlagEffectLabel(m)==fid
end

--[[
!setname 0xe19 hololive
!setname 0xd60 0th Gen
!setname 0xd61 1st Gen
!setname 0xd62 2nd Gen
!setname 0xd63 3rd Gen
!setname 0xd64 4th Gen
!setname 0xd65 5th Gen
!setname 0xd66 Gamers
!setname 0xd67 Myth
]]--
