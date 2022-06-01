--중장 토끼 - 황혼의 마녀
--카드군 번호: 0xcbd
local m=81240100
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.mat0,nil,nil,aux.NonTuner(nil),1,99)

	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(0x04)
	e1:SetCondition(cm.cn1)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valchk)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(0x10)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--싱크로 소재
function cm.mat0(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSynchroType(TYPE_UNION)
end

--내성
function cm.valchk(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcbd) then
		flag=flag|1
	end
	if #g>0 and not g:IsExists(cm.mfil0,1,nil) then
		flag=flag|2
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.mfil0(c)
	return not c:IsType(TYPE_UNION)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end

--특수 소환
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsSetCard(0xcbd)
	and ( c:IsLocation(0x10) or (c:IsLocation(0x20) and c:IsFaceup()) )
	and not c:IsCode(m)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10+0x20) and chkc:IsControler(tp) and cm.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.spfil0,tp,0x10+0x20,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfil0,tp,0x10+0x20,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		local g=Duel.GetMatchingGroup(cm.ofil0,tp,0x04,0,nil,tc)
		if tc:IsType(TYPE_UNION) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
			local sg=g:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			if tc2 and aux.CheckUnionEquip(tc,tc2) and Duel.Equip(tp,tc,tc2) then
				aux.SetUnionState(tc)
			end
		end
	end
end
function cm.ofil0(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and aux.CheckUnionEquip(ec,c)
end

--회수
function cm.tfil0(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcbd) and c:IsType(0x1) and not c:IsCode(m)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.tfil0,tp,0x10,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x10,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,0x01) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,0x01+0x40)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
