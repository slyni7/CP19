--举府胶漠房
local m=18453385
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.pfil1,nil,nil,cm.pfil2,1,99,cm.pfun1)
	local e1=MakeEff(c,"SC")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	--not fully implemented
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_ALICE_SCARLET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(0,1)
	e4:SetCondition(cm.con4)
	c:RegisterEffect(e4)
	--not fully implemented
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(0,1)
	e5:SetTarget(cm.tar5)
	e5:SetCost(cm.cost5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e6:SetTR("H",0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,"举府胶"))
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"Qo","M")
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetCL(1)
	e7:SetD(m,1)
	WriteEff(e7,7,"TO")
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"Qo","G")
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e8,8,"CTO")
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"Qo","M")
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e9:SetCL(1)
	e9:SetD(m,2)
	WriteEff(e9,9,"NTO")
	c:RegisterEffect(e9)
	--not fully implemented
	local ge1=MakeEff(c,"FC")
	ge1:SetCode(EVENT_STARTUP)
	ge1:SetOperation(cm.gop1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	Duel.RegisterEffect(ge2,1)
end
function cm.pfil1(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.pfil2(c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st) and g:IsExists(Card.IsSetCard,1,nil,"举府胶")
end
cm.square_mana={ATTRIBUTE_FIRE,0x0,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,0x0,ATTRIBUTE_WIND,ATTRIBUTE_WATER,0x0,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=1,6 do
		local e1=MakeEff(c,"S")
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"FC","M")
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetOperation(cm.oop12)
		c:RegisterEffect(e2)
	end
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rc:IsSetCard("举府胶") then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,100,REASON_EFFECT)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp==tp and rc:IsSetCard("举府胶") then
		local e1=MakeEff(c,"S")
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"FC","M")
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetOperation(cm.oop12)
		c:RegisterEffect(e2)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp~=tp then
		local e1=MakeEff(c,"S")
		e1:SetCode(m+1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"F","M")
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTR("M",0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,"举府胶"))
		e2:SetValue(100)
		c:RegisterEffect(e2)
	end
end
function cm.con4(e)
	local c=e:GetHandler()
	return #{c:IsHasEffect(m)}>#{c:IsHasEffect(m+1)}
end
function cm.tar5(e,te,ep)
	local tp=e:GetHandlerPlayer()
	if ep==tp then
		return false
	end
	if Duel.GetCurrentChain()==0 then
		return false
	end
	local res=false
	local tcode=te:GetHandler():GetCode()
	for i=1,Duel.GetCurrentChain() do
		local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local ccode=ce:GetHandler():GetCode()
		if tcode==ccode then
			res=true
			break
		end
	end
	return res
end
function cm.cost5(e,te,tp)
	return false
end
function cm.tar7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO,2700,2000,9,
				RACE_PYRO,ATTRIBUTE_FIRE)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=YuL.random(1,100)
	if val~=100 then
		if Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x0,TYPE_MONSTER+TYPE_EFFECT+TYPE_SYNCHRO,2700,2000,9,
				RACE_PYRO,ATTRIBUTE_FIRE) then
			local alice=Duel.CreateToken(tp,m)
			Duel.SpecialSummon(alice,0,tp,tp,false,false,POS_FACEUP)
			alice:CompleteProcedure()
		end
	else
		if Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,CARD_RAINBOW_FISH,0,TYPE_MONSTER+TYPE_NORMAL,1800,800,4,
				RACE_FISH,ATTRIBUTE_WATER) then
			local alice=Duel.CreateToken(tp,CARD_RAINBOW_FISH)
			Duel.SpecialSummon(alice,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(9)
			alice:RegisterEffect(e1)
		end
	end
end
function cm.cost8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)==0
	end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,0)
end
function cm.tfil8(c,tp)
	return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.tar8(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and cm.tfil8(chkc,tp)
	end
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IETarget(cm.tfil8,tp,"O","O",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.STarget(tp,cm.tfil8,tp,"O","O",1,1,nil,tp)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return #{c:IsHasEffect(m)}>=99
end
function cm.tar9(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(aux.TRUE,tp,0,"HO",nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_DESTROY,#g,g,0,0)
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,999999)
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(aux.TRUE,tp,0,"HO",nil)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,999999,REASON_EFFECT)
	end
end
function cm.gofil1(c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) or (c:IsSetCard("举府胶") and c:IsType(TYPE_QUICKPLAY))
end
function cm.goval11(c)
	return c:IsType(TYPE_QUICKPLAY) and 1 or c:GetLevel()
end
function cm.goval12(c)
	if c:IsCode(18453011) then
		return ATTRIBUTE_FIRE
	elseif c:IsCode(18453013) then
		return ATTRIBUTE_EARTH
	elseif c:IsCode(18453015) then
		return ATTRIBUTE_LIGHT
	elseif c:IsCode(18453017) then
		return ATTRIBUTE_WIND
	elseif c:IsCode(18453019) then
		return ATTRIBUTE_WATER
	elseif c:IsCode(18453021) then
		return ATTRIBUTE_DARK
	elseif c:IsCode(18453054) then
		return ATTRIBUTE_DIVINE
	end
	return 0x0
end
function cm.gofun1(g)
	if not g:CheckWithSumEqual(cm.goval11,9,#g,#g) or not g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
		or not g:IsExists(Card.IsSetCard,1,nil,"举府胶") then
		return false
	end
	local sqt={ATTRIBUTE_FIRE,0x0,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,0x0,ATTRIBUTE_WIND,ATTRIBUTE_WATER,0x0,ATTRIBUTE_DARK}
	local bchk=0x0
	local res=false
	while bchk<(1<<#g) do
		local msqt={}
		local tc=g:GetFirst()
		local index=0
		while tc do
			if tc:IsType(TYPE_QUICKPLAY) then
				table.insert(msqt,cm.goval12(tc))
			elseif bchk&(1<<index)~=0x0 then
				local tsqt=tc:GetSquareMana()
				for i=1,#tsqt do
					table.insert(msqt,tsqt[i])
				end
			else
				local lv=tc:IsType(TYPE_XYZ) and tc:GetRank() or tc:GetLevel()
				for i=1,lv do
					table.insert(msqt,tc:GetAttribute())
				end
				local esqt=tc:GetExtraSquareMana()
				for i=1,#esqt do
					table.insert(msqt,esqt[i])
				end
			end
			index=index+1
			tc=g:GetNext()
		end
		local sqbt={}
		local msqbt={}
		for i=0,127 do
			sqbt[i]=0
			msqbt[i]=0
		end
		for i=1,#sqt do
			sqbt[sqt[i]]=sqbt[sqt[i]]+1
		end
		for i=1,#msqt do
			for j=0,msqt[i] do
				if j&msqt[i]==j then
					msqbt[j]=msqbt[j]+1
				end
			end
		end
		res=true
		for i=0,127 do
			if msqbt[i]<sqbt[i] then
				res=false
				break
			end
		end
		if res then
			break
		end
		bchk=bchk+1
	end
	return res
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsControler(tp) then
	end
	local g=Duel.GMGroup(cm.gofil1,tp,"D",0,nil)
	local res=false
	for i=1,9 do
		res=g:CheckSubGroup(cm.gofun1,i,i)
		if res then
			break
		end
	end
	if res and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sres=false
		local sg=Group.CreateGroup()
		while not sres do
			sg=g:Select(tp,1,9,nil)
			sres=#sg>0 and sg:CheckSubGroup(cm.gofun1,#sg,#sg)
		end
		Duel.SendtoGrave(sg,REASON_SYNCHRO+REASON_MATERIAL)
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end