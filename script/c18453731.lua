--뱁새와 받침대
local s,id=GetID()
local skiptype={EFFECT_SKIP_DP,EFFECT_SKIP_SP,EFFECT_SKIP_M1,EFFECT_SKIP_BP,EFFECT_SKIP_M2,EFFECT_SKIP_EP,EFFECT_SKIP_TURN}
local skipphase={[EFFECT_SKIP_DP]=PHASE_DRAW
,[EFFECT_SKIP_SP]=PHASE_STANDBY
,[EFFECT_SKIP_M1]=PHASE_MAIN1
,[EFFECT_SKIP_BP]=PHASE_BATTLE
,[EFFECT_SKIP_M2]=PHASE_MAIN2
,[EFFECT_SKIP_EP]=PHASE_END
,[EFFECT_SKIP_TURN]=PHASE_DRAW|PHASE_STANDBY|PHASE_MAIN1|PHASE_BATTLE|PHASE_MAIN2|PHASE_END}
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","S")
	e2:SetCode(id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","S")
	e3:SetCode(id)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	if s.global_check==nil then
		s.global_check=true
		for i=1,#skiptype do
			s[skiptype[i]]={}
		end
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
s.phase_skip_list={8192327,13959634,35842855,53027855,59281822,61468779,44913552,2356994,81109178,218704,97639441,33393090,27995943,18452851,3078576,98287529,19230407,20618850,29223325,30430448,31562086,66712905,67835547,68957034,93229151,94445733,51670553,54631834,55870497,18452937,61557074,4008212,23471572,35316708,37576645,57069605,112603086,112603090,18453326,42291297,33541430,95480001,66011101,112600353}
s.turn_skip_list={23846921,92182447,6357341,37313786,95481805,18326736,29160023,47290012}
function s.gofil1(e)
	local c=e:GetHandler()
	for _,code in pairs(s.phase_skip_list) do
		if c:IsOriginalCode(code) then
			return true
		end
	end
	for _,code in pairs(s.turn_skip_list) do
		if c:IsOriginalCode(code) then
			return true
		end
	end
	return false
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=e:GetLabel() then
		e:SetLabel(Duel.GetTurnCount())
		local index=1
		while index<=#s[EFFECT_SKIP_M2] do
			local te=s[EFFECT_SKIP_M2][index]
			if not te or te:GetHandler():IsOriginalCode(54631834) then
				table.remove(s[EFFECT_SKIP_M2],index)
			else
				index=index+1
			end
		end
	end
	local t={}
	for i=1,#skiptype do
		t[skiptype[i]]={}
	end
	local phase=0
	for i=1,#skiptype do
		local eset0={Duel.IsPlayerAffectedByEffect(0,skiptype[i])}
		for j=1,#eset0 do
			table.insert(t[skiptype[i]],eset0[j])
		end
		local eset1={Duel.IsPlayerAffectedByEffect(1,skiptype[i])}
		for j=1,#eset1 do
			table.insert(t[skiptype[i]],eset1[j])
		end
		for j=1,#t[skiptype[i]] do
			local je=t[skiptype[i]][j]
			local res=s.gofil1(je)
			if res then
				for k=1,#s[skiptype[i]] do
					local ke=s[skiptype[i]][k]
					if je==ke then
						res=false
						break
					end
				end
				if res then
					phase=phase|skipphase[skiptype[i]]
				end
			end
		end
	end
	if phase>0 then
		Duel.RaiseEvent(Group.CreateGroup(),id,je,REASON_EFFECT,0,0,phase)
	end
	for i=1,#skiptype do
		s[skiptype[i]]={}
		for j=1,#t[skiptype[i]] do
			table.insert(s[skiptype[i]],t[skiptype[i]][j])
		end
	end
end
function s.ofil1(c)
	if not c:IsAbleToHand() then
		return false
	end
	for _,code in pairs(s.phase_skip_list) do
		if c:IsOriginalCode(code) then
			return true
		end
	end
	for _,code in pairs(s.turn_skip_list) do
		if c:IsOriginalCode(code) then
			return true
		end
	end
	return false
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id)==0
	end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.tfil2(c,skips)
	if not c:IsCustomType(CUSTOMTYPE_SQUARE) or not c:IsAbleToHand() then
		return false
	end
	if skips&PHASE_DRAW~=0 and c:GetManaCount(ATTRIBUTE_FIRE)>0 then
		return true
	end
	if skips&PHASE_STANDBY~=0 and c:GetManaCount(ATTRIBUTE_EARTH)>0 then
		return true
	end
	if skips&PHASE_MAIN1~=0 and c:GetManaCount(ATTRIBUTE_LIGHT)>0 then
		return true
	end
	if skips&PHASE_BATTLE~=0 and c:GetManaCount(ATTRIBUTE_WIND)>0 then
		return true
	end
	if skips&PHASE_MAIN2~=0 and c:GetManaCount(ATTRIBUTE_WATER)>0 then
		return true
	end
	if skips&PHASE_END~=0 and c:GetManaCount(ATTRIBUTE_DARK)>0 then
		return true
	end
	return false
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local skips=ev
	if e:GetLabel()>0 then
		skips=e:GetLabel()
	end
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil,skips)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local skips=ev
	if e:GetLabel()>0 then
		skips=e:GetLabel()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil,skips)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local ce=te:Clone()
	ce:SetCode(EVENT_PREDRAW)
	ce:SetLabel(ev)
	ce:SetReset(RESET_PHASE|PHASE_DRAW|Duel.GetCurrentPhase()|RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(ce)
end